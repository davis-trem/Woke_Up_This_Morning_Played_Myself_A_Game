class_name Events
extends Resource

const Constants = preload('res://scripts/constants.gd')

@export var events := {
	Constants.EVENT_HANDLE_GETTING_ARRESTED: {
		'options': [
			{
				'type': 'bride',
				'trigger': Constants.TRIGGER_BRIBE_JURY,
			},
			{
				'type': 'threaten',
				'trigger': Constants.TRIGGER_THREATEN_JURY,
			},
			{
				'type': 'serve',
				'trigger': Constants.TRIGGER_SERVE_JAIL_TIME,
			},
		],
	},
	Constants.EVENT_TAKE_THE_FALL_FOR_FAMILY_1: {
		'options': [
			{
				'type': 'accept',
				'stats': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.2}
				],
				'trigger': Constants.TRIGGER_ARRESTED,
			},
			{
				'type': 'deny',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.4}
				],
			},
		],
	},
}

@export var triggers := {
	Constants.TRIGGER_ARRESTED: {
		'condition': null,
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 1,
				'event': Constants.EVENT_HANDLE_GETTING_ARRESTED,
			}
		]
	},
	Constants.TRIGGER_BRIBE_JURY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					'return p.family_1_resepect * 0.1',
					'return p.family_2_resepect * 0.1',
				],
				'stat_requirements': [
					'return p.money > (50000 / (1 - clampf(p.heat, 0.01, 0.99)))',
					'return p.street_smarts > 0.3',
				],
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 'return -(50000 / (1 - clampf(p.heat, 0.01, 0.99)))'},
					{'name': Constants.PLAYER_HEAT, 'value': 0.1},
				],
			},
			{
				'action': 'denied',
				'chance': 0.5,
				'trigger': Constants.TRIGGER_SERVE_JAIL_TIME,
			}
		]
	},
	Constants.TRIGGER_SERVE_JAIL_TIME: {
		'condition': null,
		'outcomes': [
			{
				'action': 'served time',
				'chance': 1,
				'stat_updates': [
					{'name': Constants.PLAYER_STREET_SMART, 'value': 'return p.heat * 0.5'},
					{'name': Constants.PLAYER_RENTALS, 'value': 'p.rentals = p.rentals.duplicate().slice(0, clampi(2 - ceili(p.heat * 10), -p.rentals.size(), 0)) if p.rentals.size() > 0 and p.heat > 0.4 else p.rentals; return false'},
					{'name': Constants.PLAYER_BUSINESSES, 'value': 'p[Constants.PLAYER_BUSINESSES] = [] if p.heat >= 0.2 else p.businesses; return false'},
				]
			}
		]
	},
	Constants.TRIGGER_WORKING_FOR_FAMILY_1: {
		'condition': 'return p.family_1_respect > 0.5',
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 1,
				'event': Constants.EVENT_HANDLE_GETTING_ARRESTED,
			}
		]
	},
}
