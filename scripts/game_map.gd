extends Control

const Events = preload('res://resources/events.gd')
const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const SaveGame = preload('res://resources/save_game.gd')
const Constants = preload('res://scripts/constants.gd')
const Hood = preload('res://scripts/hood.gd')

@onready var neighborhood_menu = $NeighborhoodMenu
@onready var neighborhood_menu_name_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/NameLabel
@onready var neighborhood_menu_rent_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/RentLabel
@onready var neighborhood_menu_business_start_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/BusinessStartCostLabel
@onready var neighborhood_menu_business_upkeep_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/BusinessUpkeepLabel
@onready var neighborhood_menu_business_payout_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/BusinessPayoutLabel
@onready var neighborhood_menu_fam_1_ownership_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/Fam1OwnershipLabel
@onready var neighborhood_menu_fam_1_ownership_progress_bar = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/Fam1OwnershipProgressBar
@onready var neighborhood_menu_fam_2_ownership_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/Fam2OwnershipLabel
@onready var neighborhood_menu_fam_2_ownership_progress_bar = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/Fam2OwnershipProgressBar
@onready var neighborhood_menu_close_button = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/CloseButton
@onready var neighborhood_menu_actions_button = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ActionsButton
@onready var neighborhood_menu_status_label = $NeighborhoodMenu/ColorRect/MarginContainer/VBoxContainer/MarginContainer/StatusLabel
@onready var trigger_menu = $TriggerMenu
@onready var trigger_menu_description_label = $TriggerMenu/ColorRect/MarginContainer/VBoxContainer/DescriptionLabel
@onready var trigger_menu_status_label = $TriggerMenu/ColorRect/MarginContainer/VBoxContainer/StatusUpdateLabel
@onready var trigger_menu_options_button = $TriggerMenu/ColorRect/MarginContainer/VBoxContainer/OptionsButton
@onready var trigger_menu_confirm_button = $TriggerMenu/ColorRect/MarginContainer/ConfirmButton
@onready var stats_preview_money_label = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/MoneyLabel
@onready var stats_preview_sanity_progress_bar = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/SanityProgressBar
@onready var stats_preview_actions_left_progress_bar: ProgressBar = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/ActionsLeftProgressBar
@onready var stats_preview_show_stats_button = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/ShowStatsButton
@onready var stats_menu = $StatsMenu
@onready var stats_menu_money_label = $StatsMenu/ColorRect/MarginContainer/GridContainer/MoneyLabel
@onready var stats_menu_income_label = $StatsMenu/ColorRect/MarginContainer/GridContainer/IncomeLabel
@onready var stats_menu_expenses_label = $StatsMenu/ColorRect/MarginContainer/GridContainer/ExpensesLabel
@onready var stats_menu_fam_1_progress_bar = $StatsMenu/ColorRect/MarginContainer/GridContainer/Fam1RespectProgressBar
@onready var stats_menu_fam_2_progress_bar = $StatsMenu/ColorRect/MarginContainer/GridContainer/Fam2RespectProgressBar
@onready var stats_menu_heat_progress_bar = $StatsMenu/ColorRect/MarginContainer/GridContainer/HeatProgressBar
@onready var stats_menu_sanity_progress_bar = $StatsMenu/ColorRect/MarginContainer/GridContainer/SanityProgressBar
@onready var stats_menu_street_smart_progress_bar = $StatsMenu/ColorRect/MarginContainer/GridContainer/StreetSmartProgressBar
@onready var stats_menu_businesses_label = $StatsMenu/ColorRect/MarginContainer/GridContainer/BusinessesLabel
@onready var stats_menu_rentals_label = $StatsMenu/ColorRect/MarginContainer/GridContainer/RentalsLabel
@onready var stats_menu_close_button = $StatsMenu/ColorRect/MarginContainer/CloseButton
@onready var end_of_month_menu = $EndOfMonthMenu
@onready var dev_menu = $DevMenu
@onready var dev_menu_trigger_button = $DevMenu/MarginContainer/ColorRect/MenuButton
@onready var map: TextureRect = $TerritoryControl/MarginContainer/Map

@onready var events = Events.new()

enum NEIGHBORHOOD_ACTION {
	DO_CRIME,
	GET_JOB,
	QUIT_JOB,
	RENT,
	SABOTAGE_FAM_1,
	SABOTAGE_FAM_2,
	SELL_RENTAL,
	SELL_BUSINESS,
	START_BUSINESS,
	WORK_FOR_FAM_1,
	WORK_FOR_FAM_2,
}

var neighborhood_actions = [
	func (p: Player, n: NeighborhoodStats, ni: int): return (
		{'key': NEIGHBORHOOD_ACTION.RENT,
			'label': 'Rent',
			'disable': n.rent > p.money,
			'tooltip': tr('cannot_afford')}
		if not p.rentals.has(ni)
		else {'key': NEIGHBORHOOD_ACTION.SELL_RENTAL, 'label': 'Sell rental'}),
	func (p: Player, n: NeighborhoodStats, ni: int): return (
		{'key': NEIGHBORHOOD_ACTION.START_BUSINESS,
			'label': 'Start Business',
			'disable': not p.rentals.has(ni) or n.cost_to_start_business > p.money,
			'tooltip': (
				tr('cannot_afford')
				if n.cost_to_start_business > p.money
				else tr('rental_needed')
			)}
		if p.businesses.find(func (b: Dictionary): return b.get('territory_index') == ni) == -1
		else {'key': NEIGHBORHOOD_ACTION.SELL_BUSINESS, 'label': 'Sell business'}),
	func (p: Player, n: NeighborhoodStats, ni: int): return (
		{'key': NEIGHBORHOOD_ACTION.QUIT_JOB, 'label': 'Quit job'}
		if p.job == ni
		else {'key': NEIGHBORHOOD_ACTION.GET_JOB,
			'label': 'Get job',
			'disable': not p.rentals.has(ni),
			'tooltip': tr('rental_needed')}),
	func (p: Player, n: NeighborhoodStats, ni: int): return {
		'key': NEIGHBORHOOD_ACTION.DO_CRIME,
		'label': 'Do crime',
		'disable': not p.rentals.has(ni),
		'tooltip': tr('rental_needed')},
	func (p: Player, n: NeighborhoodStats, ni: int): return (
		{'key': NEIGHBORHOOD_ACTION.WORK_FOR_FAM_1,
			'label': 'Do work for Fam 1',
			'disable': not p.rentals.has(ni),
			'tooltip': tr('rental_needed')}
		if n.family_1_ownership > 0
		else null),
	func (p: Player, n: NeighborhoodStats, ni: int): return (
		{'key': NEIGHBORHOOD_ACTION.WORK_FOR_FAM_2,
			'label': 'Do work for Fam 2',
			'disable': not p.rentals.has(ni),
			'tooltip': tr('rental_needed')}
		if n.family_2_ownership > 0
		else null),
];

var start_new_game = false
var player: Player
var neighborhoods: Array[NeighborhoodStats]
var _save_game: SaveGame
var _selected_neighborhood_index

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_menu_close_button.pressed.connect(stats_menu.hide)
	
	neighborhood_menu_close_button.pressed.connect(_close_neighborhood_menu)
	neighborhood_menu_actions_button.get_popup().id_pressed.connect(_neighborhood_menu_action_selected)
	end_of_month_menu.on_continue = _continue_next_month
	end_of_month_menu.handle_lost_rental = _handle_lost_rental
	end_of_month_menu.handle_lost_business = _handle_lost_business
	_create_or_load_save()
	
	for type in events.triggers:
		dev_menu_trigger_button.get_popup().add_item(type)
	dev_menu_trigger_button.get_popup().id_pressed.connect(
		func (index):
			dev_menu.hide()
			trigger_event(
				dev_menu_trigger_button.get_popup().get_item_text(index)
			)
	)


func _process(delta):
	if player:
		stats_preview_money_label.text = '${0}'.format([
			player.money
		])
		stats_preview_sanity_progress_bar.value = player.sanity
		stats_preview_actions_left_progress_bar.value = player.actions_left
	
	if not dev_menu.visible and Input.is_action_pressed('show_dev_menu'):
		dev_menu.show()


func _create_or_load_save():
	if not start_new_game and SaveGame.save_exists():
		_save_game = SaveGame.load_savegame() as SaveGame
		events = _save_game.events
		player = _save_game.player
		_draw_territories(true)
	else:
		_save_game = SaveGame.new()
		player = Player.new()
		_save_game.player = player
		_save_game.events = events
		_draw_territories()
		_assign_player_to_neiborhood()
		_save_game.write_savegame()


func _assign_player_to_neiborhood():
	var default_hood_index = randi() % map.get_child_count()
	
	player.rentals.append(default_hood_index)
	(map.get_child(default_hood_index) as Hood).rented_icon.show()
	
	if neighborhoods[default_hood_index].family_1_ownership >= 0.8:
		player.money = 5000
		player.street_smart = 0.3
		player.heat = 0.2
		player.family_1_respect = 0.2
		player.family_2_respect = -0.2
	elif neighborhoods[default_hood_index].family_2_ownership >= 0.8:
		player.money = 10000
		player.street_smart = 0.2
		player.heat = 0.1
		player.family_1_respect = 0.2
		player.family_2_respect = -0.3
	else:
		player.money = 50000


func _draw_territories(save_exist: bool = false):
	for hood: TextureButton in map.get_children():
		var hood_index = hood.get_index()
		hood.pressed.connect(func (): _show_neighborhood_menu(hood_index))
		if save_exist:
			var neighborhood = _save_game.neighoborhood_stats_list[hood_index]
			neighborhoods.append(neighborhood)
			(map.get_child(hood_index) as Hood).name_label.text = neighborhood.name
			if player.rentals.has(hood_index):
				(map.get_child(hood_index) as Hood).rented_icon.show()
		else:
			player.territories_respect.append(0)
			
			var neighborhood = NeighborhoodStats.new()
			neighborhood.name = 'Yeer{0}'.format([hood_index])
			(map.get_child(hood_index) as Hood).name_label.text = neighborhood.name
			# 50% of map ran by fam_1, 33% ran by fam_2, 17% is neutral
			if hood_index == 3:
				neighborhood.family_1_ownership = 0.0
				neighborhood.family_2_ownership = 0.0
				neighborhood.job_payout = [700, 800, 900][randi() % 3]
				neighborhood.business_payout = [7000, 8000, 9000][randi() % 3]
				neighborhood.cost_to_start_business = [80000, 90000, 100000][randi() % 3]
				neighborhood.cost_to_run_business = [8000, 9000, 10000][randi() % 3]
				neighborhood.rent = [7000, 8000, 9000][randi() % 3]
			elif hood_index < 3:
				neighborhood.family_1_ownership = 1.0
				neighborhood.family_2_ownership = 0.0
				neighborhood.job_payout = [100, 200, 300][randi() % 3]
				neighborhood.business_payout = [1000, 2000, 3000][randi() % 3]
				neighborhood.cost_to_start_business = [20000, 30000, 40000][randi() % 3]
				neighborhood.cost_to_run_business = [2000, 3000, 4000][randi() % 3]
				neighborhood.rent = [1000, 2000, 3000][randi() % 3]
			else:
				neighborhood.family_1_ownership = 0.0
				neighborhood.family_2_ownership = 1.0
				neighborhood.job_payout = [400, 500, 600][randi() % 3]
				neighborhood.business_payout = [4000, 5000, 6000][randi() % 3]
				neighborhood.cost_to_start_business = [50000, 60000, 70000][randi() % 3]
				neighborhood.cost_to_run_business = [5000, 6000, 7000][randi() % 3]
				neighborhood.rent = [4000, 5000, 6000][randi() % 3]
			
			neighborhoods.append(neighborhood)
				
			_save_game.neighoborhood_stats_list.append(neighborhoods[hood_index])


func _draw_neighborhood_menu_action_button_options(hood_index: int):
	var neighborhood = neighborhoods[hood_index]
	neighborhood_menu_actions_button.get_popup().clear()
	for action_func in neighborhood_actions:
		var action = action_func.call(player, neighborhood, hood_index)
		if action != null:
			neighborhood_menu_actions_button.get_popup().add_item(action.get('label'), action.get('key'))
			if action.get('disable') or player.actions_left == 0:
				var index = neighborhood_menu_actions_button.get_popup().get_item_index(action.get('key'))
				neighborhood_menu_actions_button.get_popup().set_item_disabled(index, true)
				if action.get('tooltip'):
					neighborhood_menu_actions_button.get_popup().set_item_tooltip(index, action.get('tooltip'))


func _show_neighborhood_menu(hood_index: int):
	_draw_neighborhood_menu_action_button_options(hood_index)
	
	_selected_neighborhood_index = hood_index
	
	neighborhood_menu_name_label.text = neighborhoods[hood_index].get('name')
	neighborhood_menu_rent_label.text = 'Rent: ${0}'.format([neighborhoods[hood_index].rent])
	neighborhood_menu_business_start_label.text = 'Cost to Start Business: ${0}'.format([neighborhoods[hood_index].cost_to_start_business])
	neighborhood_menu_business_upkeep_label.text = 'Cost to Upkeep Business: ${0}'.format([neighborhoods[hood_index].cost_to_run_business])
	neighborhood_menu_business_payout_label.text = 'Business Payout: ${0}'.format([neighborhoods[hood_index].business_payout])
	neighborhood_menu_fam_1_ownership_label.text = '{0} Ownership:'.format(['Family 1'])
	neighborhood_menu_fam_2_ownership_label.text = '{0} Ownership:'.format(['Family 2'])
	neighborhood_menu_fam_1_ownership_progress_bar.value = neighborhoods[hood_index].family_1_ownership
	neighborhood_menu_fam_2_ownership_progress_bar.value = neighborhoods[hood_index].family_2_ownership
	neighborhood_menu_status_label.hide()
	neighborhood_menu.show()


func _close_neighborhood_menu():
	_selected_neighborhood_index = null
	neighborhood_menu.hide()


func _neighborhood_menu_action_selected(id):
	trigger_menu_description_label.text = ''
	trigger_menu_status_label.text = ''
	trigger_menu_options_button.get_popup().clear()
	trigger_menu_options_button.hide()
	trigger_menu_confirm_button.hide()
	var neighborhood = neighborhoods[_selected_neighborhood_index]
	var stat_updates = [];
	match id:
		NEIGHBORHOOD_ACTION.DO_CRIME:
			var money = randi_range(1000, 3000)
			var heat = snappedf(randf_range(0.1, 0.3), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			stat_updates = [
				{'name': Constants.PLAYER_MONEY, 'value': money},
				{'name': Constants.PLAYER_HEAT, 'value': heat},
				{'name': Constants.PLAYER_STREET_SMART, 'value': street_smart},
			]
		NEIGHBORHOOD_ACTION.GET_JOB:
			stat_updates = [
				{
					'name': Constants.PLAYER_JOB,
					'value': 'p.job = {0}; return false'.format([_selected_neighborhood_index])
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).job_icon.show()
		NEIGHBORHOOD_ACTION.QUIT_JOB:
			stat_updates = [
				{
					'name': Constants.PLAYER_JOB,
					'value': 'p.job = -1; return false'
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).job_icon.hide()
		NEIGHBORHOOD_ACTION.RENT:
			stat_updates = [
				{'name': Constants.PLAYER_MONEY, 'value': -neighborhood.rent},
				{
					'name': Constants.PLAYER_RENTALS,
					'value': 'p.rentals.append({0}); return false'.format([_selected_neighborhood_index])
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).rented_icon.show()
		NEIGHBORHOOD_ACTION.SABOTAGE_FAM_1:
			pass
		NEIGHBORHOOD_ACTION.SABOTAGE_FAM_2:
			pass
		NEIGHBORHOOD_ACTION.SELL_RENTAL:
			stat_updates = [
				{'name': Constants.PLAYER_MONEY, 'value': neighborhood.rent},
				{
					'name': Constants.PLAYER_RENTALS,
					'value': 'p.rentals = p.rentals.filter(func (i): return i != {0}); return false'.format([_selected_neighborhood_index])
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).rented_icon.hide()
		NEIGHBORHOOD_ACTION.SELL_BUSINESS:
			var index = player.businesses.find(
				func (b): return b.get('territory_index') == _selected_neighborhood_index
			)
			stat_updates = [
				{'name': Constants.PLAYER_MONEY, 'value': neighborhood.cost_to_start_business},
				{
					'name': Constants.PLAYER_BUSINESSES,
					'value': 'p.businesses.pop_at({0}); return false'.format([index])
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).company_icon.hide()
		NEIGHBORHOOD_ACTION.START_BUSINESS:
			stat_updates = [
				{'name': Constants.PLAYER_MONEY, 'value': -neighborhood.cost_to_start_business},
				{
					'name': Constants.PLAYER_BUSINESSES,
					'value': 'p.businesses.append({"territory_index": {0}}); return false'.format([_selected_neighborhood_index])
				},
			]
			(map.get_child(_selected_neighborhood_index) as Hood).company_icon.show()
		NEIGHBORHOOD_ACTION.WORK_FOR_FAM_1:
			var respect = 0.1
			var money = randi_range(3000, 5000)
			var heat = snappedf(randf_range(0.2, 0.5), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			stat_updates = [
				{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': respect},
				{'name': Constants.PLAYER_MONEY, 'value': money},
				{'name': Constants.PLAYER_HEAT, 'value': heat},
				{'name': Constants.PLAYER_STREET_SMART, 'value': street_smart},
			]
		NEIGHBORHOOD_ACTION.WORK_FOR_FAM_2:
			var respect = 0.1
			var money = randi_range(2500, 4000)
			var heat = snappedf(randf_range(0.2, 0.4), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			stat_updates = [
				{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': respect},
				{'name': Constants.PLAYER_MONEY, 'value': money},
				{'name': Constants.PLAYER_HEAT, 'value': heat},
				{'name': Constants.PLAYER_STREET_SMART, 'value': street_smart},
			]
	
	_draw_neighborhood_menu_action_button_options(_selected_neighborhood_index)
	for stat in stat_updates:
		_handle_stat_updates(stat)
	
	if id == NEIGHBORHOOD_ACTION.SELL_RENTAL:
		_handle_lost_rental(_selected_neighborhood_index)
	
	neighborhood_menu.hide()
	
	player.actions_left -= 1
	trigger_menu_description_label.text = '{0}'.format([id])
	trigger_menu_confirm_button.pressed.connect(_continue_from_neighborhood_menu_action, CONNECT_ONE_SHOT)
	trigger_menu_confirm_button.show()
	trigger_menu.show()


func _continue_from_neighborhood_menu_action():
	_hide_trigger_menu()
	if player.actions_left == 0:
		_show_end_of_month_menu()
	else:
		var odds = randi_range(0, 3) # Trigger event third of the time
		if odds == 0:
			trigger_event()


func trigger_event(trigger_type = null):
	trigger_menu_description_label.text = ''
	trigger_menu_status_label.text = ''
	trigger_menu_options_button.get_popup().clear()
	trigger_menu_options_button.hide()
	trigger_menu_confirm_button.hide()
	
	var applicable_outcomes = [];
	if trigger_type != null:
		for outcome in events.triggers[trigger_type].get('outcomes'):
			if outcome.get('triggered_by') == null:
				outcome['triggered_by'] = trigger_type
		applicable_outcomes = events.triggers[trigger_type].get('outcomes')
	else:
		for type in events.triggers:
			var condition = events.triggers[type].get('condition')
			if (
				not player.past_four_triggers.has(type)
				and typeof(condition) == TYPE_STRING
				and _evaluateString(condition)
			):
				for outcome in events.triggers[type].get('outcomes'):
					if outcome.get('triggered_by') == null:
						outcome['triggered_by'] = type
				applicable_outcomes.append_array(events.triggers[type].get('outcomes'))
	
	if applicable_outcomes.size() == 0:
		return
	
	var outcomes = _calculate_outcomes_accumulated_chance(applicable_outcomes)
	var chance = randf_range(0, outcomes[outcomes.size() - 1].get('accumulated_chance'))
	for outcome in outcomes:
		if outcome.get('accumulated_chance') > chance:
			player.past_four_triggers.append(outcome.get('triggered_by'))
			if (player.past_four_triggers.size() > 4):
				player.past_four_triggers.pop_front()
			
			trigger_menu_description_label.text = outcome.get('triggered_by')
			trigger_menu.show()
			for stat_update in outcome.get('stat_updates', []):
				_handle_stat_updates(stat_update)
			if outcome.get('trigger'):
				trigger_menu_confirm_button.pressed.connect(
					func (): trigger_event(outcome.get('trigger')),
					CONNECT_ONE_SHOT
				)
				trigger_menu_confirm_button.show()
			elif outcome.get('event'):
				var event_options = events.events.get(outcome.get('event')).get('options')
				for option in event_options:
					trigger_menu_options_button.get_popup().add_item(option.get('type'))
				trigger_menu_options_button.get_popup().id_pressed.connect(
					func (id): _trigger_menu_option_selected(
						id,
						event_options
					)
				)
				trigger_menu_options_button.show()
			else:
				trigger_menu_confirm_button.pressed.connect(_hide_trigger_menu, CONNECT_ONE_SHOT)
				trigger_menu_confirm_button.show()
			break
	
	if _save_game:
		_save_game.write_savegame()


func _handle_stat_updates(stat_update):
	var stat_name = stat_update.get('name')
	var old_value = (
		player.get(stat_name).duplicate()
		if typeof(player.get(stat_name)) == TYPE_ARRAY or typeof(player.get(stat_name)) == TYPE_DICTIONARY
		else player.get(stat_name)
	)
	
	var update_value = (
		_evaluateString(stat_update.get('value'))
		if typeof(stat_update.get('value')) == TYPE_STRING
		else stat_update.get('value')
	)
	
	var new_value
	if typeof(update_value) == TYPE_BOOL and update_value == false:
		new_value = player.get(stat_name)
	else:
		var limits = Constants.STATS_LIMITS.get(stat_name)
		new_value = clampf(
			player.get(stat_name) + update_value,
			limits.get('min'),
			limits.get('max')
		) if limits\
			else player.get(stat_name) + update_value
		
		player.set(stat_name, new_value)
		
	var change_text = (
		'lost' if (
			(
				(typeof(new_value) == TYPE_ARRAY or typeof(new_value) == TYPE_DICTIONARY)
				and old_value.size() > new_value.size()
			)
			or (
				(typeof(new_value) != TYPE_ARRAY and typeof(new_value) != TYPE_DICTIONARY)
				and old_value > new_value
			)
		)
		else 'gained'
	)
	
	trigger_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
		'CHANGE': change_text,
		'STAT': stat_name,
		'DIFF': (
			new_value.size() - old_value.size()
			if typeof(new_value) == TYPE_ARRAY or typeof(new_value) == TYPE_DICTIONARY
			else new_value - old_value
		)
	}) + '\n'


func _hide_trigger_menu():
	trigger_menu.hide()


func _trigger_menu_option_selected(selected_id, options):
	trigger_menu_description_label.text =\
		trigger_menu_options_button.get_popup().get_item_text(selected_id)
	trigger_menu_status_label.text = ''
	trigger_menu_options_button.hide()
	var text = trigger_menu_options_button.get_popup().get_item_text(selected_id)
	for option in options:
		# Found selected event option
		if text == option.get('type'):
			var continue_func = ((func (): trigger_event(option.get('trigger')))
				if option.get('trigger')
				else _hide_trigger_menu)
			
			# If there isn't any stats to show then go straight to trigger/menu close
			if option.get('stat_updates', []).size() == 0:
				continue_func.call()
				return
			
			for stat_update in option.get('stat_updates', []):
				_handle_stat_updates(stat_update)
			trigger_menu_confirm_button.pressed.connect(continue_func, CONNECT_ONE_SHOT)
			trigger_menu_confirm_button.show()
			_save_game.write_savegame()
			return


func _calculate_outcomes_accumulated_chance(outcomes: Array) -> Array:
	var outcomes_accumulated_chance = []
	var accumulated_chance = 0
	for outcome in outcomes:
		var meets_stat_requirements = true
		for stat_requirement in outcome.get('stat_requirements', []):
			if not _evaluateString(stat_requirement):
				meets_stat_requirements = false
				break
		if not meets_stat_requirements:
			continue
	
		for chance_multipler in outcome.get('chance_multiplers', []):
			accumulated_chance += _evaluateString(chance_multipler)
		accumulated_chance += outcome.get('chance')
		
		outcomes_accumulated_chance.append(outcome)
		outcomes_accumulated_chance[outcomes_accumulated_chance.size() - 1]['accumulated_chance'] = accumulated_chance
	outcomes_accumulated_chance.sort_custom(
		func (a, b): return a.get('accumulated_chance') < b.get('accumulated_chance')
	)
	return outcomes_accumulated_chance


func _evaluateString(command: String):
	var script = GDScript.new()
	script.set_source_code('func eval(p):' + command)
	script.reload()
	var ref = RefCounted.new()
	ref.set_script(script)
	return ref.eval(player)


func _calculate_total_expenses_amount() -> int:
	var total_rent = 0
	for hood_index in player.rentals:
		total_rent += neighborhoods[hood_index].rent
	
	var total_business_costs = 0
	for business in player.businesses:
		total_business_costs += neighborhoods[business.get('territory_index')].cost_to_run_business
		if business.get('extortioner'):
			pass # TODO
			
	var total_loan_payments = 0
	for loan in player.loans:
		pass # TODO
	
	return total_rent + total_business_costs + total_loan_payments


func _calculate_total_expenses() -> Dictionary:
	var cannot_afford_rentals = []
	var cannot_afford_businesses = []
	var rental_expenses = 0
	var businesses_expenses = 0
	for hood_index in player.rentals:
		var rent = neighborhoods[hood_index].rent
		if player.money >= rent:
			rental_expenses += rent
		else:
			cannot_afford_rentals.append(hood_index)
		# Check if owns business in territory
		for business in player.businesses:
			if business.get('territory_index') == hood_index:
				var business_cost = neighborhoods[hood_index].cost_to_run_business
				if business.get('extortioner'):
					pass # TODO
				
				# if cannot afford rent then cannot keep business
				if (
					cannot_afford_rentals.find(hood_index) == -1
					and player.money >= business_cost
				):
					businesses_expenses += business_cost
				else:
					cannot_afford_businesses.append(hood_index)
	
	for territory_index in cannot_afford_rentals:
		player.rentals = player.rentals.filter(func (ti): ti != territory_index)
	
	for territory_index in cannot_afford_businesses:
		player.businesses = player.businesses.filter(
			func (b): b.get('territory_index') != territory_index
		)
	
	for loan in player.loans:
		pass # TODO
	
	return {
		'cannot_afford': {
			'retails': cannot_afford_rentals,
			'businesses': cannot_afford_businesses,
		},
		'expenses': {
			'rental_expenses': rental_expenses,
			'businesses_expenses': businesses_expenses
		}
	}


func _calculate_total_income() -> Dictionary:
	var job_payout = 0
	if player.job != -1:
		job_payout = neighborhoods[player.job].job_payout
	
	var total_business_payout = 0
	for business in player.businesses:
		total_business_payout += neighborhoods[business.get('territory_index')].business_payout
	
	var fam_1_payout = 0
	if player.family_1_respect >= 0.7:
		pass # TODO
	
	var fam_2_payout = 0
	if player.family_2_respect >= 0.7:
		pass # TODO
	
	return {
		'job_payout': job_payout,
		'total_business_payout':total_business_payout,
		'fam_1_payout': fam_1_payout,
		'fam_2_payout': fam_2_payout
	}


func _show_end_of_month_menu():
	end_of_month_menu.details_label.text = ''
	var total_income := _calculate_total_income()
	for key in total_income:
		if total_income[key] > 0:
			player.money += total_income[key]
			end_of_month_menu.details_label.text += tr(key).format({
				'payout': total_income[key],
				'businesses': ', '.join(
					player.businesses.map(
						func(b): return neighborhoods[b.get('territory_index')].name
					)
				),
				'fam_1': 'fam_1',
				'fam_2': 'fam_2'
			}) + '\n'
	
	end_of_month_menu.player = player
	end_of_month_menu.neighborhoods = neighborhoods
	end_of_month_menu.render()


func _continue_next_month():
	_save_game.write_savegame()
	player.current_month += 1
	player.actions_left = 3
	
	end_of_month_menu.hide()
	
	if player.sanity <= 0:
		print('player ends')
	else:
		trigger_event()


func _handle_lost_rental(hood_index: int):
	player.rentals = player.rentals.filter(func (hi): return hi != hood_index)
	if player.job == hood_index:
		player.job = -1
	var business_index = player.businesses.find(
		func (b): return b.get('territory_index') == hood_index
	)
	if business_index != -1:
		player.businesses.pop_at(business_index)
	
	(map.get_child(hood_index) as Hood).rented_icon.hide()
	(map.get_child(hood_index) as Hood).company_icon.hide()
	(map.get_child(hood_index) as Hood).job_icon.hide()


func _handle_lost_business(hood_index: int):
	var business_index = player.businesses.find(
		func (b): return b.get('territory_index') == hood_index
	)
	if business_index != -1:
		player.businesses.pop_at(business_index)
	
	(map.get_child(hood_index) as Hood).company_icon.hide()


func _show_stats_menu():
	stats_menu_money_label.text = '${0}'.format([player.money])
	stats_menu_income_label.text = '${0}'.format([
		_calculate_total_income().values().reduce(func(total, num): return total + num, 0)
	])
	stats_menu_expenses_label.text = '${0}'.format([_calculate_total_expenses_amount()])
	stats_menu_fam_1_progress_bar.value = player.family_1_respect
	stats_menu_fam_2_progress_bar.value = player.family_2_respect
	stats_menu_heat_progress_bar.value = player.heat
	stats_menu_sanity_progress_bar.value = player.sanity
	stats_menu_street_smart_progress_bar.value = player.street_smart
	stats_menu_businesses_label.text = ''
	for business in player.businesses:
		stats_menu_businesses_label.text += neighborhoods[
			business.get('territory_index')
		].name + '\n'
	stats_menu_rentals_label.text = ''
	for territory_index in player.rentals:
		stats_menu_rentals_label.text += neighborhoods[
			territory_index
		].name + '\n'
	stats_menu.show()


func _on_show_stats_button_pressed():
	_show_stats_menu()


func _on_end_month_button_pressed() -> void:
	_show_end_of_month_menu()
