extends Control

const Events = preload('res://resources/events.gd')
const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const SaveGame = preload('res://resources/save_game.gd')
const neighborhood_scene = preload('res://scenes/neighborhood.tscn')
const Constants = preload('res://scripts/constants.gd')
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
@onready var stats_preview_expenses_countdown_progress_bar = $StatsPreviewControl/Panel/MarginContainer/HBoxContainer/ExpensesCountdownProgressBar
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
@onready var status_notifier = $StatusNotifier
@onready var status_notifier_details_label = $StatusNotifier/MarginContainer/ColorRect/MarginContainer/VBoxContainer/DetailsLabel
@onready var status_notifier_continue_button = $StatusNotifier/MarginContainer/ColorRect/MarginContainer/VBoxContainer/ContinueButton
@onready var dev_menu = $DevMenu
@onready var dev_menu_trigger_button = $DevMenu/MarginContainer/ColorRect/MenuButton

@onready var events = Events.new()

@export var territory_count: int = 9

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
	func (p: Player, n: Neighborhood): return (
		{'key': NEIGHBORHOOD_ACTION.RENT, 'label': 'Rent', 'disable': n.stats.rent > p.money}
		if not p.rentals.has(n.get_index())
		else {'key': NEIGHBORHOOD_ACTION.SELL_RENTAL, 'label': 'Sell rental'}),
	func (p: Player, n: Neighborhood): return (
		{'key': NEIGHBORHOOD_ACTION.START_BUSINESS,
			'label': 'Start Business',
			'disable': not p.rentals.has(n.get_index()) or n.stats.cost_to_start_business > p.money}
		if p.businesses.find(func (b: Dictionary): return b.get('territory_index') == n.get_index()) == -1
		else {'key': NEIGHBORHOOD_ACTION.SELL_BUSINESS, 'label': 'Sell business'}),
	func (p: Player, n: Neighborhood): return (
		{'key': NEIGHBORHOOD_ACTION.QUIT_JOB, 'label': 'Quit job'}
		if p.job.get('territory_index') == n.get_index()
		else {'key': NEIGHBORHOOD_ACTION.GET_JOB,
			'label': 'Get job',
			'disable': not p.rentals.has(n.get_index())}),
	func (p: Player, n: Neighborhood): return {'key': NEIGHBORHOOD_ACTION.DO_CRIME,
		'label': 'Do crime', 'disable': not p.rentals.has(n.get_index())},
	func (p: Player, n: Neighborhood): return (
		{'key': NEIGHBORHOOD_ACTION.WORK_FOR_FAM_1,
			'label': 'Do work for Fam 1',
			'disable': not p.rentals.has(n.get_index())}
		if n.stats.family_1_ownership > 0
		else null),
	func (p: Player, n: Neighborhood): return (
		{'key': NEIGHBORHOOD_ACTION.WORK_FOR_FAM_2,
			'label': 'Do work for Fam 2',
			'disable': not p.rentals.has(n.get_index())}
		if n.stats.family_2_ownership > 0
		else null),
];

var start_new_game = false
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
	neighborhood_menu_actions_button.get_popup().id_pressed.connect(_neighborhood_menu_action_selected)
	_create_or_load_save()
	
	for type in events.triggers:
		dev_menu_trigger_button.get_popup().add_item(type)
	dev_menu_trigger_button.get_popup().id_pressed.connect(
		func (index):
			dev_menu.hide()
			trigger_event(
				players[multiplayer_unique_id],
				dev_menu_trigger_button.get_popup().get_item_text(index)
			)
	)
	
	event_timer.start()


func _process(delta):
	if players.get(local_player_multiplayer_unique_id):
		stats_preview_money_label.text = '${0}'.format([
			players[local_player_multiplayer_unique_id].money
		])
		stats_preview_sanity_progress_bar.value = players[local_player_multiplayer_unique_id].sanity
	
	stats_preview_expenses_countdown_progress_bar.value = event_timer.time_left / event_timer.wait_time
	
	if not dev_menu.visible and Input.is_action_pressed('show_dev_menu'):
		event_timer.stop()
		dev_menu.show()


func _create_or_load_save():
	if not start_new_game and SaveGame.save_exists():
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


func _draw_neighborhood_menu_action_button_options(player: Player, neighborhood: Neighborhood):
	neighborhood_menu_actions_button.get_popup().clear()
	for action_func in neighborhood_actions:
		var action = action_func.call(player, neighborhood)
		if action != null:
			neighborhood_menu_actions_button.get_popup().add_item(action.get('label'), action.get('key'))
			if action.get('disable'):
				var index = neighborhood_menu_actions_button.get_popup().get_item_index(action.get('key'))
				neighborhood_menu_actions_button.get_popup().set_item_disabled(index, true)


func _show_neighborhood_menu(neighborhood: Neighborhood):
	var player: Player = players[local_player_multiplayer_unique_id]
	
	_draw_neighborhood_menu_action_button_options(player, neighborhood)
	
	_selected_neighborhood_index = neighborhood.get_index()
	
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
	var player: Player = players[local_player_multiplayer_unique_id]
	var neighborhood: Neighborhood = territories.get_child(_selected_neighborhood_index)
	match id:
		NEIGHBORHOOD_ACTION.DO_CRIME:
			var heat_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_HEAT)
			var street_smart_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_STREET_SMART)
			var money = randi_range(1000, 3000)
			var heat = snappedf(randf_range(0.1, 0.3), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			neighborhood_menu_status_label.text = 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'dollars',
				'DIFF': money
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'heat',
				'DIFF': heat
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'street smart',
				'DIFF': street_smart
			}) + '\n'
			
			player.money += money
			player.heat = clampf(
				player.heat + heat,
				heat_limits.get('min'),
				heat_limits.get('max')
			)
			player.street_smart = clampf(
				player.street_smart + street_smart,
				street_smart_limits.get('min'),
				street_smart_limits.get('max')
			)
		NEIGHBORHOOD_ACTION.GET_JOB:
			player.job = {'territory_index': _selected_neighborhood_index}
		NEIGHBORHOOD_ACTION.QUIT_JOB:
			player.job = {}
		NEIGHBORHOOD_ACTION.RENT:
			player.money -= neighborhood.stats.rent
			player.rentals.append(_selected_neighborhood_index)
			neighborhood.status_label.text = 'Rented'
			neighborhood_menu_status_label.text = 'Territory rented for ${AMOUNT}'.format({
				'AMOUNT': neighborhood.stats.rent
			})
		NEIGHBORHOOD_ACTION.SABOTAGE_FAM_1:
			pass
		NEIGHBORHOOD_ACTION.SABOTAGE_FAM_2:
			pass
		NEIGHBORHOOD_ACTION.SELL_RENTAL:
			player.rentals = player.rentals.filter(func (i): return i != _selected_neighborhood_index)
			player.money += neighborhood.stats.rent
			neighborhood.status_label.text = ''
			neighborhood_menu_status_label.text = 'Rental sold for ${AMOUNT}'.format({
				'AMOUNT': neighborhood.stats.rent
			})
		NEIGHBORHOOD_ACTION.SELL_BUSINESS:
			var index = player.businesses.find(
				func (b): return b.get('territory_index') == _selected_neighborhood_index
			)
			player.businesses.pop_at(index)
			player.money += neighborhood.stats.cost_to_start_business
			neighborhood_menu_status_label.text = 'Business sold for ${AMOUNT}'.format({
				'AMOUNT': neighborhood.stats.cost_to_start_business
			})
		NEIGHBORHOOD_ACTION.START_BUSINESS:
			player.money -= neighborhood.stats.cost_to_start_business
			player.businesses.append({'territory_index': _selected_neighborhood_index})
			neighborhood_menu_status_label.text = 'Business started for ${AMOUNT}'.format({
				'AMOUNT': neighborhood.stats.cost_to_start_business
			})
		NEIGHBORHOOD_ACTION.WORK_FOR_FAM_1:
			var respect_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_FAMILY_1_RESPECT)
			var heat_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_HEAT)
			var street_smart_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_STREET_SMART)
			var respect = 0.1
			var money = randi_range(3000, 5000)
			var heat = snappedf(randf_range(0.2, 0.5), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			neighborhood_menu_status_label.text = 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'dollars',
				'DIFF': money
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'family_1_respect',
				'DIFF': respect
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'heat',
				'DIFF': heat
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'street smart',
				'DIFF': street_smart
			}) + '\n'
			
			player.family_1_respect = clampf(
				player.family_1_respect + respect,
				respect_limits.get('min'),
				respect_limits.get('max')
			)
			player.money += money
			player.heat = clampf(
				player.heat + heat,
				heat_limits.get('min'),
				heat_limits.get('max')
			)
			player.street_smart = clampf(
				player.street_smart + street_smart,
				street_smart_limits.get('min'),
				street_smart_limits.get('max')
			)
		NEIGHBORHOOD_ACTION.WORK_FOR_FAM_2:
			var respect_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_FAMILY_2_RESPECT)
			var heat_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_HEAT)
			var street_smart_limits = Constants.STATS_LIMITS.get(Constants.PLAYER_STREET_SMART)
			var respect = 0.1
			var money = randi_range(2500, 4000)
			var heat = snappedf(randf_range(0.2, 0.4), 0.01)
			var street_smart = snappedf(randf_range(0.1, 0.3), 0.01)
			
			neighborhood_menu_status_label.text = 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'dollars',
				'DIFF': money
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'family_1_respect',
				'DIFF': respect
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'heat',
				'DIFF': heat
			}) + '\n'
			neighborhood_menu_status_label.text += 'You have {CHANGE} {DIFF} {STAT}'.format({
				'CHANGE': 'gained',
				'STAT': 'street smart',
				'DIFF': street_smart
			}) + '\n'
			
			player.family_2_respect = clampf(
				player.family_2_respect + respect,
				respect_limits.get('min'),
				respect_limits.get('max')
			)
			player.money += money
			player.heat = clampf(
				player.heat + heat,
				heat_limits.get('min'),
				heat_limits.get('max')
			)
			player.street_smart = clampf(
				player.street_smart + street_smart,
				street_smart_limits.get('min'),
				street_smart_limits.get('max')
			)
	
	neighborhood_menu_status_label.show()
	_draw_neighborhood_menu_action_button_options(player, neighborhood)
#	TODO: figure out if we wanna trigger event after selecting neighborhood option
#	trigger_event(player)
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
	trigger_menu_description_label.text =\
		trigger_menu_options_button.get_popup().get_item_text(selected_id)
	trigger_menu_status_label.text = ''
	trigger_menu_options_button.hide()
	var text = trigger_menu_options_button.get_popup().get_item_text(selected_id)
	for option in options:
		# Found selected event option
		if text == option.get('type'):
			var continue_func = ((func (): trigger_event(player, option.get('trigger')))
				if option.get('trigger')
				else _hide_trigger_menu)
			
			# If there isn't any stats to show then go straight to trigger/menu close
			if option.get('stat_updates', []).size() == 0:
				continue_func.call()
				return
			
			for stat_update in option.get('stat_updates', []):
				_handle_stat_updates(stat_update, player)
			trigger_menu_confirm_button.pressed.connect(continue_func)
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


func _calculate_total_expenses_amount() -> int:
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


func _calculate_total_expenses() -> Dictionary:
	var player: Player = players[local_player_multiplayer_unique_id]
	
	var cannot_afford_rentals = []
	var cannot_afford_businesses = []
	var rental_expenses = 0
	var businesses_expenses = 0
	for territory_index in player.rentals:
		var rent = territories.get_child(territory_index).stats.rent
		if player.money >= rent:
			rental_expenses += rent
		else:
			cannot_afford_rentals.append(territory_index)
		# Check if owns business in territory
		for business in player.businesses:
			if business.get('territory_index') == territory_index:
				var business_cost = territories.get_child(territory_index).stats.cost_to_run_business
				if business.get('extortioner'):
					pass # TODO
				
				# if cannot afford rent then cannot keep business
				if (
					cannot_afford_rentals.find(territory_index) == -1
					and player.money >= business_cost
				):
					businesses_expenses += business_cost
				else:
					cannot_afford_businesses.append(territory_index)
	
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
	
	return {
		'job_payout': job_payout,
		'total_business_payout':total_business_payout,
		'fam_1_payout': fam_1_payout,
		'fam_2_payout': fam_2_payout
	}


func _notify_status_updates():
	var player: Player = players[local_player_multiplayer_unique_id]
	
	var total_income := _calculate_total_income()
	for key in total_income:
		if total_income[key] > 0:
			player.money + total_income[key]
			status_notifier_details_label.text += tr(key).format({
				'payout': total_income[key],
				'businesses': ', '.join(
					player.businesses.map(
						func(b): return territories.get_child(b.get('territory_index')).stats.name
					)
				),
				'fam_1': 'fam_1',
				'fam_2': 'fam_2'
			}) + '\n'
	status_notifier_details_label.text += '\n'
	
	var total_expenses := _calculate_total_expenses()
	var cannot_afford_details = ''
	if total_expenses.get('cannot_afford').get('retails').size() > 0:
		player.rentals = player.rentals.filter(
			func (ti): !total_expenses.get('cannot_afford').get('retails').has(ti)
		)
		# Update board to show as no longer rented
		for territory_index in total_expenses.get('cannot_afford').get('retails'):
			territories.get_child(territory_index).status_label = ''
		cannot_afford_details += tr('cannot_afford_retails').format({
			'rentals': ', '.join(total_expenses.get('cannot_afford').get('retails').map(
				func (ti): return territories.get_child(ti).stats.name
			))
		}) + '\n'
	if total_expenses.get('cannot_afford').get('businesses').size() > 0:
		player.businesses = player.businesses.filter(
			func (b): !total_expenses.get('cannot_afford').get('businesses').has(b.get('territory_index'))
		)
		cannot_afford_details += tr('cannot_afford_businesses').format({
			'businesses': ', '.join(total_expenses.get('cannot_afford').get('businesses').map(
				func (b): return territories.get_child(b.get('territory_index')).stats.name
			))
		}) + '\n'
	
	for key in total_expenses.get('expenses'):
		if total_expenses.get('expenses')[key] > 0:
			player.money -= total_expenses.get('expenses').get(key)
			status_notifier_details_label.text += tr(key).format({
				'expense': total_expenses.get('expenses').get(key),
				'rentals': ', '.join(player.rentals.map(
					func (ti): return territories.get_child(ti).stats.name
				)),
				'businesses': ', '.join(player.businesses.map(
					func (b): return territories.get_child(b.get('territory_index')).stats.name
				))
			}) + '\n'
	status_notifier_details_label.text += cannot_afford_details + '\n'
	
	
	if player.rentals.size() == 0:
		player.sanity -= 0.3
		status_notifier_details_label.text += tr('lost_sanity_because_homeless')\
			.format({'amount': 0.3}) + '\n\n'
	
	if player.sanity <= 0:
		status_notifier_details_label.text += tr('player_died')

	_save_game.write_savegame()
	
	status_notifier_continue_button.pressed.connect(
		func():
			status_notifier.hide()
			status_notifier_details_label.text = ''
			if player.sanity <= 0:
				print('player ends')
			else:
				trigger_event(player)
	)
	if player.sanity < 0:
		print('player ends')
	
	
	status_notifier.show()


func _on_event_timer_timeout():
	event_timer.stop()
	
	_notify_status_updates()


func _show_stats_menu():
	var player: Player = players[local_player_multiplayer_unique_id]
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
