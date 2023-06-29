extends Node2D

var neighborhood_scene = preload('res://scenes/neighborhood.tscn')

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

@export var territory_count: int = 9

enum NEIGHBORHOOD_ACTIONS {
	RENT,
	START_BUSINESS,
}

var players = {}
var local_player_multiplayer_unique_id

# Called when the node enters the scene tree for the first time.
func _ready():
	var multiplayer_unique_id = multiplayer.get_unique_id()
	add_player(multiplayer_unique_id)
	
	neighborhood_menu_close_button.connect('pressed', neighborhood_menu.hide)
	for action in NEIGHBORHOOD_ACTIONS:
		neighborhood_menu_actions_button.get_popup().add_item(action)
	neighborhood_menu_actions_button.get_popup().connect('id_pressed', _neighborhood_menu_action_selected)
	_draw_territories()


func add_player(peer_id):
	set_multiplayer_authority(peer_id)
	players[peer_id] = Player.new()
	if peer_id == multiplayer.get_unique_id():
		local_player_multiplayer_unique_id = peer_id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw_territories():
	for i in range(territory_count):
		var neighborhood = neighborhood_scene.instantiate()
		neighborhood.set_input_handler(_neighborhood_input_handler)
		neighborhood.stats = {
			'name': 'Yeer{0}'.format([i]),
			'business_model': {
				'cost_to_start': 11,
				'cost_to_run': 0,
				'payout': 0,
			},
			'family_1_ownership': 0,
			'family_2_ownership': 0.5,
			'rent': 0,
		}
		territories.add_child(neighborhood)


func _neighborhood_input_handler(event: InputEvent, neighborhood: Neighborhood):
	if not neighborhood_menu.visible:
		_show_neighborhood_menu(neighborhood)


func _show_neighborhood_menu(neighborhood: Neighborhood):
	print(neighborhood.get_index())
	neighborhood_menu_name_label.text = neighborhood.stats.get('name')
	neighborhood_menu_rent_label.text = 'Rent: ${0}'.format([neighborhood.stats.get('rent')])
	neighborhood_menu_business_start_label.text = 'Cost to Start Business: ${0}'.format([neighborhood.stats.get('business_model').get('cost_to_start')])
	neighborhood_menu_business_upkeep_label.text = 'Cost to Upkeep Business: ${0}'.format([neighborhood.stats.get('business_model').get('cost_to_run')])
	neighborhood_menu_business_payout_label.text = 'Business Payout: ${0}'.format([neighborhood.stats.get('business_model').get('payout')])
	neighborhood_menu_fam_1_ownership_label.text = '{0} Ownership:'.format(['Family 1'])
	neighborhood_menu_fam_2_ownership_label.text = '{0} Ownership:'.format(['Family 2'])
	neighborhood_menu_fam_1_ownership_progress_bar.value = neighborhood.stats.get('family_1_ownership')
	neighborhood_menu_fam_2_ownership_progress_bar.value = neighborhood.stats.get('family_2_ownership')
	neighborhood_menu.show()


func _neighborhood_menu_action_selected(id):
	var text = neighborhood_menu_actions_button.get_popup().get_item_text(id)
	print(id, text)
	match id:
		NEIGHBORHOOD_ACTIONS.RENT:
			print('pooo')
		NEIGHBORHOOD_ACTIONS.START_BUSINESS:
			pass
