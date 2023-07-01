extends Node2D

const Events = preload('res://resources/events.gd')
const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const SaveGame = preload('res://resources/save_game.gd')
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
	var multiplayer_unique_id = multiplayer.get_unique_id()
	add_player(multiplayer_unique_id)
	
	neighborhood_menu_close_button.connect('pressed', _close_neighborhood_menu)
	for action in NEIGHBORHOOD_ACTIONS:
		neighborhood_menu_actions_button.get_popup().add_item(action)
	neighborhood_menu_actions_button.get_popup().connect('id_pressed', _neighborhood_menu_action_selected)
	_create_or_load_save()


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
		_save_game.write_savegame()


func add_player(peer_id):
	set_multiplayer_authority(peer_id)
	players[peer_id] = Player.new()
	players[peer_id].id = peer_id
	if peer_id == multiplayer.get_unique_id():
		local_player_multiplayer_unique_id = peer_id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw_territories(size: int = territory_count, save_exist: bool = false):
	for i in range(size):
		var neighborhood = neighborhood_scene.instantiate()
		neighborhood.set_input_handler(_neighborhood_input_handler)
		
		if save_exist:
			neighborhood.stats = _save_game.neighoborhood_stats_list[i]
		else:
			neighborhood.stats = NeighborhoodStats.new()
			neighborhood.stats.name = 'Yeer{0}'.format([i])
			neighborhood.stats.business_payout = 0
			neighborhood.stats.cost_to_start_business = 5000
			neighborhood.stats.cost_to_run_business = 0
			neighborhood.stats.family_1_ownership = 0.0
			neighborhood.stats.family_2_ownership = 0.6
			neighborhood.stats.rent = 1000
			_save_game.neighoborhood_stats_list.append(neighborhood.stats)
		
		if players[local_player_multiplayer_unique_id].rentals.has(i):
			neighborhood.initial_status_label_text = 'Rented'
		
		territories.add_child(neighborhood)


func _neighborhood_input_handler(event: InputEvent, neighborhood: Neighborhood):
	if not neighborhood_menu.visible:
		_show_neighborhood_menu(neighborhood)


func _show_neighborhood_menu(neighborhood: Neighborhood):
	print(neighborhood.get_index())
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
	print(id, text)
	match id:
		NEIGHBORHOOD_ACTIONS.RENT:
			players[local_player_multiplayer_unique_id].rentals.append(_selected_neighborhood_index)
			territories.get_child(_selected_neighborhood_index).status_label.text = 'Rented'
			neighborhood_menu_status_label.text = 'Territory Rented'
			neighborhood_menu_status_label.show()
		NEIGHBORHOOD_ACTIONS.START_BUSINESS:
			pass
	_save_game.write_savegame()


func trigger_event(player: Player, trigger_type):
	var applicable_outcomes = [];
	if trigger_type != null:
		applicable_outcomes = events.triggers[trigger_type].get('outcomes')
	else:
		for type in events.triggers:
			var condition = events.triggers[type].get('condition')
			if typeof(condition) == TYPE_STRING and _evaluateString(condition, player):
				applicable_outcomes.append_array(events.triggers[type].get('outcomes'))
	
	var outcomes = _calculate_outcomes_accumulated_chance(applicable_outcomes, player)
	var chance = randf_range(0, outcomes[outcomes.size() - 1].get('accumulated_chance'))
	for outcome in outcomes:
		if outcome.get('accumulated_chance') > chance:
			for stat_update in outcome.get('stat_updates', []):
				var update_value = (
					_evaluateString(stat_update.get('value'), player)
					if typeof(stat_update.get('value')) == TYPE_STRING
					else stat_update.get('value')
				)
				if not (typeof(update_value) == TYPE_BOOL and update_value == false):
					player.set(stat_update.get('name'), update_value)
			if outcome.get('trigger'):
				trigger_event(player, outcome.get('trigger'))
			elif outcome.get('event'):
				# Present Event
				pass
	
	if _save_game:
		_save_game.write_savegame()


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
		outcomes_accumulated_chance.append(outcome)
		outcomes_accumulated_chance[outcomes_accumulated_chance.size() - 1]['accumulated_chance'] = accumulated_chance + outcome.get('chance')
	return outcomes_accumulated_chance


func _evaluateString(command: String, player):
	var script = GDScript.new()
	script.set_source_code('func eval(p):' + command)
	script.reload()
	var ref = RefCounted.new()
	ref.set_script(script)
	return ref.eval(player)
