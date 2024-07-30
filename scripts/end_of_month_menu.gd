extends Panel

const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const ROW_H_SLIDER = preload('res://scenes/row_h_slider.tscn')
const ROW_NAME_LABEL = preload('res://scenes/row_name_label.tscn')
const ROW_OWED_LABEL = preload('res://scenes/row_owed_label.tscn')
const ROW_PAID_LINE_EDIT = preload('res://scenes/row_paid_line_edit.tscn')

@onready var grid_container: GridContainer = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var money_label: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/MoneyLabel
@onready var continue_button: Button = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/ContinueButton
@onready var details_label: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/DetailsLabel

var player: Player
var neighborhoods: Array[NeighborhoodStats]
var on_continue: Callable
var handle_lost_rental: Callable
var handle_lost_business: Callable
var rows: Array[Dictionary] = []
var money: int
var non_numbers_regex := RegEx.new()

func _ready() -> void:
	non_numbers_regex.compile('\\D+')
	continue_button.pressed.connect(_on_continue_button_pressed)


func render() -> void:
	money = player.money
	money_label.text = 'Money: ${0}'.format([money])
	rows = []
	for i in grid_container.get_child_count():
		if i > 3: # Skip table headers
			grid_container.get_child(i).queue_free()
	
	for hood_index in player.rentals:
		var hood := neighborhoods[hood_index]
		_add_new_row(hood_index, hood.name, 'Rental', hood.rent, false)
		
	for business in player.businesses:
		var hood_index = business.get('hood_index')
		var hood := neighborhoods[hood_index]
		_add_new_row(hood_index, hood.name, 'Business', hood.cost_to_run_business, false)
		if business.get('extortion'):
			_add_new_row(
				hood_index,
				hood.name,
				'Business Extortion',
				(hood.business_payout * business['extortion']['rate']) + business['extortion']['owed'],
				true
			)
	
	for loan_index in player.loans.size():
		var loan = player.loans[loan_index]
		var owed = loan['owed'] + (loan['owed'] * loan['rate'])
		_add_new_row(loan_index, loan['by'], 'Loan', owed, true)
	
	show()


func _add_new_row(hood_index: int, name: String, type: String, amount: int, allow_step: bool) -> void:
	var index := rows.size()
	
	var name_label: Label = ROW_NAME_LABEL.instantiate()
	name_label.text = '{0}: {1}'.format([type, name])
	
	var owed_label: Label = ROW_OWED_LABEL.instantiate()
	owed_label.text = '${0}'.format([amount])
	
	var slider: HSlider = ROW_H_SLIDER.instantiate()
	if not allow_step:
		slider.step = amount
	slider.value_changed.connect(func(value): _on_slider_value_changed(index, value))
	
	var paid_input: LineEdit = ROW_PAID_LINE_EDIT.instantiate()
	paid_input.text_changed.connect(func (new_text): _on_paid_input_changed(index, new_text))
	
	rows.append({
		'hood_index': hood_index,
		'amount': amount,
		'allow_step': allow_step,
		'name': name,
		'type': type,
		'value': 0,
		'owed': owed_label,
		'slider': slider,
		'paid': paid_input
	})
	
	_update_inputs_status(index)
	
	grid_container.add_child(name_label)
	grid_container.add_child(owed_label)
	grid_container.add_child(slider)
	grid_container.add_child(paid_input)


func _on_value_changed(index: int, payment: int) -> void:
	details_label.text = ''
	var change = rows[index]['value'] - payment
	money += change
	money_label.text = 'Money: ${0}'.format([money])
	rows[index]['value'] = payment
	rows[index]['owed'].text = '${0}'.format([rows[index]['amount'] - payment])
	for i in rows.size():
		_update_inputs_status(i)


func _update_inputs_status(index: int) -> void:
	var must_pay_in_full_and_cannot_afford = (
		not rows[index]['allow_step']
		and money < rows[index]['amount']
		and rows[index]['value'] == 0
	)
	rows[index]['paid'].editable = rows[index]['allow_step']
	rows[index]['slider'].editable = not must_pay_in_full_and_cannot_afford
	
	if not rows[index]['allow_step'] and rows[index]['value'] != rows[index]['amount']:
		details_label.text += 'You will lose {0} {1}\n'.format([
			rows[index]['type'],
			rows[index]['name']
		])
		
	if rows[index]['allow_step']:
		rows[index]['slider'].max_value = (
			rows[index]['amount']
			if rows[index]['amount'] < money
			else rows[index]['value'] + money
		)
	else:
		rows[index]['slider'].max_value = rows[index]['amount']


func _on_slider_value_changed(index: int, value: float) -> void:
	rows[index]['paid'].text = '${0}'.format([rows[index]['slider'].value])
	_on_value_changed(index, int(rows[index]['slider'].value))


func _on_paid_input_changed(index: int, new_text: String) -> void:
	var text := non_numbers_regex.sub(new_text, '', true)
	var value = 0 if text == '' else int(text)
	rows[index]['paid'].text = '' if value == 0 else '${0}'.format([value])
	rows[index]['slider'].value = value
	_on_value_changed(index, value)


func _on_continue_button_pressed():
	var expenses := 0
	for row in rows:
		expenses += row['value']
		if not row['allow_step'] and row['value'] == 0:
			match row['type']:
				'Rental':
					handle_lost_rental.call(row['hood_index'])
				'Business':
					handle_lost_business.call(row['hood_index'])
		elif row['allow_step']:
			match row['type']:
				'Business Extortion':
					for i in player.businesses.size():
						if player.businesses[i]['hood_index'] == row['hood_index']:
							player.businesses[i]['extortion']['owed'] = row['amount'] - row['value']
							break
				'Loan':
					player.loans[row['hood_index']]['owed'] = row['amount'] - row['value']
	
	player.money -= expenses
	if player.rentals.size() == 0:
		player.sanity -= 0.3
	hide()
	on_continue.call()
