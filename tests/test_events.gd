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
	var game_map = game_map_scene.instantiate()
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

