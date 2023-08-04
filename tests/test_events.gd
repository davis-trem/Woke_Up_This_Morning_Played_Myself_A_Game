extends GutTest

const Events = preload('res://resources/events.gd')
const Player = preload('res://resources/player.gd')
const game_map_scene = preload('res://screens/game_map.tscn')
const Constants = preload('res://scripts/constants.gd')


func test_trigger_event(params=use_parameters(ParameterFactory.named_parameters(
	['heat', 'street_smart', 'rentals_size', 'businesses_size'],
	[
		[0.8, 0.4, 4, 0],
		[0.15, 0.075, 10, 5],
		[0.2, 0.1, 10, 0],
	]
))):
	var game_map = create_game_map()
	var events: Events = Events.new()
	game_map.events = events
	
	var player: Player = Player.new()
	player.heat = params.heat
	player.rentals = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
	player.businesses = [{}, {}, {}, {}, {}]
	game_map.trigger_event(player, Constants.TRIGGER_SERVE_JAIL_TIME)
	# street_smart should increase by half of heat 
	assert_eq(player.street_smart, params.street_smart)
	# if player.heat > 0.4 loss (heat*10 - 2) rentals, else rentals aren't touched
	assert_eq(player.rentals.size(), params.rentals_size)
	# if player.heat >= 0.2 loss all businesses, else businesses aren't touched
	assert_eq(player.businesses.size(), params.businesses_size)


func test_trigger_menu_options_button_items_reset():
	var game_map = create_game_map()
	var events: Events = Events.new()
	game_map.events = events
	var player: Player = Player.new()
	
	assert_eq(game_map.trigger_menu_options_button.get_popup().item_count, 0)
	
	game_map.trigger_event(player, Constants.TRIGGER_ROBBED_BY_FAMILY_1)
	assert_eq(
		game_map.trigger_menu_options_button.get_popup().item_count,
		events.events[Constants.EVENT_ROBBED_BY_FAMILY_1].get('options').size()
	)
	
	game_map.trigger_event(player, Constants.TRIGGER_ROBBED_BY_FAMILY_2)
	assert_eq(
		game_map.trigger_menu_options_button.get_popup().item_count,
		events.events[Constants.EVENT_ROBBED_BY_FAMILY_2].get('options').size()
	)


func create_game_map():
	var game_map = game_map_scene.instantiate()
	
	game_map.trigger_menu = Panel.new()
	game_map.trigger_menu_description_label = Label.new()
	game_map.trigger_menu_status_label = Label.new()
	game_map.trigger_menu_options_button = MenuButton.new()
	game_map.trigger_menu_confirm_button = Button.new()
	
	return game_map
