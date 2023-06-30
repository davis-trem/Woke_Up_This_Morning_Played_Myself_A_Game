extends GutTest

const Events = preload('res://scripts/events.gd')
const Player = preload('res://scripts/player.gd')


func test_trigger_event(params=use_parameters(ParameterFactory.named_parameters(
	['heat', 'street_smart', 'rentals_size', 'businesses_size'],
	[
		[0.8, 0.4, 4, 0],
		[0.15, 0.075, 10, 5],
		[0.2, 0.1, 10, 0],
	]
))):
	var events = Events.new()
	var player = Player.new()
	player.stats[Player.STAT_TYPE.HEAT] = params.heat
	player.stats[Player.STAT_TYPE.RENTALS] = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
	player.stats[Player.STAT_TYPE.BUSINESSES] = [{}, {}, {}, {}, {}]
	events.trigger_event(player, events.TRIGGER_TYPE.SERVE_JAIL_TIME)
	assert_eq(player.stats[Player.STAT_TYPE.STREET_SMART], params.street_smart)
	assert_eq(player.stats[Player.STAT_TYPE.RENTALS].size(), params.rentals_size)
	assert_eq(player.stats[Player.STAT_TYPE.BUSINESSES].size(), params.businesses_size)
