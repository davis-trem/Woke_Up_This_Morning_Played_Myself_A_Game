extends Node2D

const Events = preload('res://resources/events.gd')
const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const SaveGame = preload('res://resources/save_game.gd')
const Constants = preload('res://scripts/constants.gd')
const neighborhood_scene = preload('res://scenes/neighborhood.tscn')
const Neighborhood = preload('res://scripts/neighborhood.gd')

@onready var territories = $TerritoryControl/Territories
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
@onready var event_timer = $EventTimer
@onready var stats_preview_money_label = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/MoneyLabel
@onready var stats_preview_sanity_progress_bar = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/SanityProgressBar
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

@onready var events = Events.new()

@export var territory_count: int = 9

enum NEIGHBORHOOD_ACTIONS {
	RENT,
	START_BUSINESS,
}

var players = {}
var local_player_multiplayer_unique_id
var _save_game: SaveGame
var _selected_neighborhood_index

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_menu_close_button.pressed.connect(stats_menu.hide)
	
	var multiplayer_unique_id = multiplayer.get_unique_id()
	add_player(multiplayer_unique_id)
	
	neighborhood_menu_close_button.pressed.connect(_close_neighborhood_menu)
	for action in NEIGHBORHOOD_ACTIONS:
		neighborhood_menu_actions_button.get_popup().add_item(action)
	neighborhood_menu_actions_button.get_popup().id_pressed.connect(_neighborhood_menu_action_selected)
	_create_or_load_save()
	event_timer.start()


func _process(delta):
	if players.get(local_player_multiplayer_unique_id):
		stats_preview_money_label.text = '${0}'.format([
			players[local_player_multiplayer_unique_id].money
		])
		stats_preview_sanity_progress_bar.value = players[local_player_multiplayer_unique_id].sanity


func _create_or_load_save():
	if SaveGame.save_exists():
		_save_game = SaveGame.load_savegame() as SaveGame
		events = _save_game.events
		players = _save_game.players
		_draw_territories(_save_game.neighoborhood_stats_list.size(), true)
	else:
		_save_game = SaveGame.new()
		_save_game.players = players
		_save_game.events = events
		_draw_territories()
		_assign_player_to_neiborhood()
		_save_game.write_savegame()


func add_player(peer_id):
	set_multiplayer_authority(peer_id)
	players[peer_id] = Player.new()
	players[peer_id].id = peer_id
	if peer_id == multiplayer.get_unique_id():
		local_player_multiplayer_unique_id = peer_id


func _assign_player_to_neiborhood():
	var territory_index = randi() % territories.get_child_count()
	
	players[local_player_multiplayer_unique_id].rentals.append(territory_index)
	territories.get_child(territory_index).status_label.text = 'Rented'
	
	if territories.get_child(territory_index).stats.family_1_ownership >= 0.8:
		players[local_player_multiplayer_unique_id].money = 5000
		players[local_player_multiplayer_unique_id].street_smart = 0.3
		players[local_player_multiplayer_unique_id].heat = 0.2
		players[local_player_multiplayer_unique_id].family_1_respect = 0.2
		players[local_player_multiplayer_unique_id].family_2_respect = -0.2
	elif territories.get_child(territory_index).stats.family_2_ownership >= 0.8:
		players[local_player_multiplayer_unique_id].money = 10000
		players[local_player_multiplayer_unique_id].street_smart = 0.2
		players[local_player_multiplayer_unique_id].heat = 0.1
		players[local_player_multiplayer_unique_id].family_1_respect = 0.2
		players[local_player_multiplayer_unique_id].family_2_respect = -0.3
	else:
		players[local_player_multiplayer_unique_id].money = 50000


func _draw_territories(size: int = territory_count, save_exist: bool = false):
	for i in range(size):
		var neighborhood = neighborhood_scene.instantiate()
		neighborhood.pressed.connect(func (): _show_neighborhood_menu(neighborhood))
		
		if save_exist:
			neighborhood.stats = _save_game.neighoborhood_stats_list[i]
			if players[local_player_multiplayer_unique_id].rentals.has(i):
				neighborhood.initial_status_label_text = 'Rented'
		else:
			players[local_player_multiplayer_unique_id].territories_respect.append(0)
			
			neighborhood.stats = NeighborhoodStats.new()
			neighborhood.stats.name = 'Yeer{0}'.format([i])
			# 50% of map ran by fam_1, 30% ran by fam_2, 20% is neutral
			if i < size / 2:
				neighborhood.stats.family_1_ownership = 1.0
				neighborhood.stats.family_2_ownership = 0.0
				neighborhood.stats.job_payout = [100, 200, 300][randi() % 3]
				neighborhood.stats.business_payout = [1000, 2000, 3000][randi() % 3]
				neighborhood.stats.cost_to_start_business = [20000, 30000, 40000][randi() % 3]
				neighborhood.stats.cost_to_run_business = [2000, 3000, 4000][randi() % 3]
				neighborhood.stats.rent = [1000, 2000, 3000][randi() % 3]
			elif i <= (size / 2 + ((size / 2) / 2)):
				neighborhood.stats.family_1_ownership = 0.0
				neighborhood.stats.family_2_ownership = 1.0
				neighborhood.stats.job_payout = [400, 500, 600][randi() % 3]
				neighborhood.stats.business_payout = [4000, 5000, 6000][randi() % 3]
				neighborhood.stats.cost_to_start_business = [50000, 60000, 70000][randi() % 3]
				neighborhood.stats.cost_to_run_business = [5000, 6000, 7000][randi() % 3]
				neighborhood.stats.rent = [4000, 5000, 6000][randi() % 3]
			else:
				neighborhood.stats.family_1_ownership = 0.0
				neighborhood.stats.family_2_ownership = 0.0
				neighborhood.stats.job_payout = [700, 800, 900][randi() % 3]
				neighborhood.stats.business_payout = [7000, 8000, 9000][randi() % 3]
				neighborhood.stats.cost_to_start_business = [80000, 90000, 100000][randi() % 3]
				neighborhood.stats.cost_to_run_business = [8000, 9000, 10000][randi() % 3]
				neighborhood.stats.rent = [7000, 8000, 9000][randi() % 3]
			_save_game.neighoborhood_stats_list.append(neighborhood.stats)
		
		territories.add_child(neighborhood)


func _show_neighborhood_menu(neighborhood: Neighborhood):
	_selected_neighborhood_index = neighborhood.get_index()
	
	neighborhood_menu_actions_button.get_popup().set_item_disabled(
		0,
		players[local_player_multiplayer_unique_id].rentals.has(_selected_neighborhood_index)
	)
	neighborhood_menu_name_label.text = neighborhood.stats.get('name')
	neighborhood_menu_rent_label.text = 'Rent: ${0}'.format([neighborhood.stats.rent])
	neighborhood_menu_business_start_label.text = 'Cost to Start Business: ${0}'.format([neighborhood.stats.cost_to_start_business])
	neighborhood_menu_business_upkeep_label.text = 'Cost to Upkeep Business: ${0}'.format([neighborhood.stats.cost_to_run_business])
	neighborhood_menu_business_payout_label.text = 'Business Payout: ${0}'.format([neighborhood.stats.business_payout])
	neighborhood_menu_fam_1_ownership_label.text = '{0} Ownership:'.format(['Family 1'])
	neighborhood_menu_fam_2_ownership_label.text = '{0} Ownership:'.format(['Family 2'])
	neighborhood_menu_fam_1_ownership_progress_bar.value = neighborhood.stats.family_1_ownership
	neighborhood_menu_fam_2_ownership_progress_bar.value = neighborhood.stats.family_2_ownership
	neighborhood_menu_status_label.hide()
	neighborhood_menu.show()


func _close_neighborhood_menu():
	_selected_neighborhood_index = null
	neighborhood_menu.hide()


func _neighborhood_menu_action_selected(id):
	var text = neighborhood_menu_actions_button.get_popup().get_item_text(id)
	match id:
		NEIGHBORHOOD_ACTIONS.RENT:
			players[local_player_multiplayer_unique_id].rentals.append(_selected_neighborhood_index)
			territories.get_child(_selected_neighborhood_index).status_label.text = 'Rented'
			neighborhood_menu_status_label.text = 'Territory Rented'
			neighborhood_menu_status_label.show()
		NEIGHBORHOOD_ACTIONS.START_BUSINESS:
			pass
	trigger_event(players[local_player_multiplayer_unique_id])
	_save_game.write_savegame()


func trigger_event(player: Player, trigger_type = null):
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
				and _evaluateString(condition, player)
			):
				for outcome in events.triggers[type].get('outcomes'):
					if outcome.get('triggered_by') == null:
						outcome['triggered_by'] = type
				applicable_outcomes.append_array(events.triggers[type].get('outcomes'))
	
	if applicable_outcomes.size() == 0:
		return
	
	var outcomes = _calculate_outcomes_accumulated_chance(applicable_outcomes, player)
	var chance = randf_range(0, outcomes[outcomes.size() - 1].get('accumulated_chance'))
	for outcome in outcomes:
		if outcome.get('accumulated_chance') > chance:
			player.past_four_triggers.append(outcome.get('triggered_by'))
			if (player.past_four_triggers.size() > 4):
				player.past_four_triggers.pop_front()
			
			trigger_menu_description_label.text = outcome.get('triggered_by')
			trigger_menu.show()
			for stat_update in outcome.get('stat_updates', []):
				_handle_stat_updates(stat_update, player)
			if outcome.get('trigger'):
				trigger_menu_confirm_button.pressed.connect(
					func (): trigger_event(player, outcome.get('trigger'))
				)
				trigger_menu_confirm_button.show()
			elif outcome.get('event'):
				var event_options = events.events.get(outcome.get('event')).get('options')
				for option in event_options:
					trigger_menu_options_button.get_popup().add_item(option.get('type'))
				trigger_menu_options_button.get_popup().id_pressed.connect(
					func (id): _trigger_menu_option_selected(
						id,
						event_options,
						player
					)
				)
				trigger_menu_options_button.show()
			else:
				trigger_menu_confirm_button.pressed.connect(_hide_trigger_menu)
				trigger_menu_confirm_button.show()
			break
	
	if _save_game:
		_save_game.write_savegame()


func _handle_stat_updates(stat_update, player: Player):
	var stat_name = stat_update.get('name')
	var old_value = player.get(stat_name)
	
	var update_value = (
		_evaluateString(stat_update.get('value'), player)
		if typeof(stat_update.get('value')) == TYPE_STRING
		else stat_update.get('value')
	)
	var limits = Constants.STATS_LIMITS.get(stat_name)
	var new_value = clampf(
		player.get(stat_name) + update_value,
		limits.get('min'),
		limits.get('max')
	) if limits\
		else player.get(stat_name) + update_value
	if not (typeof(update_value) == TYPE_BOOL and update_value == false):
		player.set(stat_name, new_value)
		
	var change_text = (
		'lost' if (
			(typeof(new_value) == TYPE_ARRAY and old_value.size() > new_value.size())
			or old_value > new_value
		)
		else 'gained'
	)
	
	trigger_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
		'CHANGE': change_text,
		'STAT': stat_name,
		'DIFF': (
			new_value.size() - old_value.size() if typeof(new_value) == TYPE_ARRAY
			else new_value - old_value
		)
	}) + '\n'


func _hide_trigger_menu():
	trigger_menu.hide()
	event_timer.start()


func _trigger_menu_option_selected(selected_id, options, player):
	trigger_menu_description_label.text = ''
	trigger_menu_status_label.text = ''
	trigger_menu_options_button.hide()
	var text = trigger_menu_options_button.get_popup().get_item_text(selected_id)
	for option in options:
		# Found selected event option
		if text == option.get('type'):
			for stat_update in option.get('stat_updates', []):
				_handle_stat_updates(stat_update, player)
			trigger_menu_confirm_button.pressed.connect(
				(func (): trigger_event(player, option.get('trigger'))) if option.get('trigger')
				else _hide_trigger_menu
			)
			trigger_menu_confirm_button.show()
			_save_game.write_savegame()
			return


func _calculate_outcomes_accumulated_chance(outcomes: Array, player) -> Array:
	var outcomes_accumulated_chance = []
	var accumulated_chance = 0
	for outcome in outcomes:
		var meets_stat_requirements = true
		for stat_requirement in outcome.get('stat_requirements', []):
			if not _evaluateString(stat_requirement, player):
				meets_stat_requirements = false
				break
		if not meets_stat_requirements:
			continue
	
		for chance_multipler in outcome.get('chance_multiplers', []):
			accumulated_chance += _evaluateString(chance_multipler, player)
		accumulated_chance += outcome.get('chance')
		
		outcomes_accumulated_chance.append(outcome)
		outcomes_accumulated_chance[outcomes_accumulated_chance.size() - 1]['accumulated_chance'] = accumulated_chance
	outcomes_accumulated_chance.sort_custom(
		func (a, b): return a.get('accumulated_chance') < b.get('accumulated_chance')
	)
	return outcomes_accumulated_chance


func _evaluateString(command: String, player):
	var script = GDScript.new()
	script.set_source_code('func eval(p):' + command)
	script.reload()
	var ref = RefCounted.new()
	ref.set_script(script)
	return ref.eval(player)


func _calculate_total_expenses():
	var player: Player = players[local_player_multiplayer_unique_id]
	
	var total_rent = 0
	for territory_index in player.rentals:
		total_rent += territories.get_child(territory_index).stats.rent
	
	var total_business_costs = 0
	for business in player.businesses:
		total_business_costs += territories\
			.get_child(business.get('territory_index')).stats.cost_to_run_business
		if business.get('extortioner'):
			pass # TODO
			
	var total_loan_payments = 0
	for loan in player.loans:
		pass # TODO
	
	return total_rent + total_business_costs + total_loan_payments


func _apply_expenses():
	var player: Player = players[local_player_multiplayer_unique_id]
	
	var cannot_afford = {'rentals': [], 'businesses': []}
	for territory_index in player.rentals:
		var rent = territories.get_child(territory_index).stats.rent
		if player.money >= rent:
			player.money -= rent
		else:
			cannot_afford['rentals'].append(territory_index)
		# Check if owns business in territory
		for business in player.businesses:
			if business.get('territory_index') == territory_index:
				var business_cost = territories.get_child(territory_index).stats.cost_to_run_business
				if business.get('extortioner'):
					pass # TODO
				
				# if cannot afford rent then cannot keep business
				if (
					cannot_afford.get('rentals').find(territory_index) == -1
					and player.money >= business_cost
				):
					player.money -= business_cost
				else:
					cannot_afford['businesses'].append(territory_index)
	
	for territory_index in cannot_afford.get('rentals'):
		player.rentals = player.rentals.filter(func (ti): ti != territory_index)
	
	for territory_index in cannot_afford.get('businesses'):
		player.businesses = player.businesses.filter(
			func (b): b.get('territory_index') != territory_index
		)
	
	for loan in player.loans:
		pass # TODO


func _calculate_total_income():
	var player: Player = players[local_player_multiplayer_unique_id]
	
	var job_payout = 0
	if player.job and player.job.get('territory_index'):
		job_payout = territories.get_child(player.job.get('territory_index')).stats.job_payout
	
	var total_business_payout = 0
	for business in player.businesses:
		total_business_payout += territories\
			.get_child(business.get('territory_index')).stats.business_payout
	
	var fam_1_payout = 0
	if player.family_1_respect >= 0.7:
		pass # TODO
	
	var fam_2_payout = 0
	if player.family_2_respect >= 0.7:
		pass # TODO
	
	return job_payout + total_business_payout + fam_1_payout + fam_2_payout


func _on_event_timer_timeout():
	event_timer.stop()
	var player: Player = players[local_player_multiplayer_unique_id]
	player.money += _calculate_total_income()
	_apply_expenses()

	if player.rentals.size() == 0:
		player.sanity -= 0.3

	if player.sanity < 0:
		print('player ends')
	
	_save_game.write_savegame()

	trigger_event(players[local_player_multiplayer_unique_id])
	if not trigger_menu.visible:
		event_timer.start()


func _show_stats_menu():
	var player: Player = players[local_player_multiplayer_unique_id]
	stats_menu_money_label.text = '${0}'.format([player.money])
	stats_menu_income_label.text = '${0}'.format([_calculate_total_income()])
	stats_menu_expenses_label.text = '${0}'.format([_calculate_total_expenses()])
	stats_menu_fam_1_progress_bar.value = player.family_1_respect
	stats_menu_fam_2_progress_bar.value = player.family_2_respect
	stats_menu_heat_progress_bar.value = player.heat
	stats_menu_sanity_progress_bar.value = player.sanity
	stats_menu_street_smart_progress_bar.value = player.street_smart
	stats_menu_businesses_label.text = ''
	for business in player.businesses:
		stats_menu_businesses_label.text += territories.get_child(
			business.get('territory_index')
		).stats.name + '\n'
	stats_menu_rentals_label.text = ''
	for territory_index in player.rentals:
		stats_menu_rentals_label.text += territories.get_child(
			territory_index
		).stats.name + '\n'
	stats_menu.show()


func _on_show_stats_button_pressed():
	_show_stats_menu()
