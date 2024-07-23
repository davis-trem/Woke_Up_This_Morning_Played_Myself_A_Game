class_name Events
extends Resource

const Constants = preload('res://scripts/constants.gd')

@export var events := {
	Constants.EVENT_BANK_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 10000}
				]
			},
			{
				'type': 'decline',
			}
		]
	},
	Constants.EVENT_FAMILY_1_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 500}
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_OFFERS_WORK: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 1000},
					{'name': Constants.PLAYER_HEAT, 'value': 0.3},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 1000},
					{'name': Constants.PLAYER_HEAT, 'value': 0.3},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_WANTS_TO_EXTORT_BUSINESS: { # TODO: fix
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -1000},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS: { # TODO: fix
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 500},
					{'name': Constants.PLAYER_HEAT, 'value': 0.3},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 1000},
					{'name': Constants.PLAYER_HEAT, 'value': 0.4},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 800}
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_OFFERS_WORK: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 600},
					{'name': Constants.PLAYER_HEAT, 'value': 0.2},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 500},
					{'name': Constants.PLAYER_HEAT, 'value': 0.2},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_WANTS_TO_EXTORT_BUSINESS: { # TODO: fix
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -700},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS: { # TODO: fix
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 250},
					{'name': Constants.PLAYER_HEAT, 'value': 0.2},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 1000},
					{'name': Constants.PLAYER_HEAT, 'value': 0.4},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FEDS_WANT_PROOF_OF_INCOME: { # TODO: fix
		'options': [
			{
				'type': 'accept',
			},
			{
				'type': 'decline',
				'trigger': Constants.TRIGGER_ARRESTED
			}
		]
	},
	Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_1: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.1},
					{'name': Constants.PLAYER_HEAT, 'value': -0.4},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.3},
				],
				'trigger': Constants.TRIGGER_ARRESTED
			}
		]
	},
	Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_2: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.5},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.2},
					{'name': Constants.PLAYER_HEAT, 'value': -0.4},
				]
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.3},
				],
				'trigger': Constants.TRIGGER_ARRESTED
			}
		]
	},
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
	Constants.EVENT_HIT_ATTEMPTED_BY_FAMILY_1: {
		'options': [
			{
				'type': 'fight back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.3},
				],
			},
			{
				'type': 'allow it',
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
		]
	},
	Constants.EVENT_HIT_ATTEMPTED_BY_FAMILY_2: {
		'options': [
			{
				'type': 'fight back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.2},
				],
			},
			{
				'type': 'allow it',
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
		]
	},
	Constants.EVENT_ROBBED_BY_FAMILY_1: {
		'options': [
			{
				'type': 'fight back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.2},
				],
			},
			{
				'type': 'allow it',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -1000},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.2},
				],
			},
		]
	},
	Constants.EVENT_ROBBED_BY_FAMILY_2: {
		'options': [
			{
				'type': 'fight back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.5},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.2},
				],
			},
			{
				'type': 'allow it',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -2000},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
				],
			},
		]
	},
	Constants.EVENT_ROBBED_BY_STREET_GANG: {
		'options': [
			{
				'type': 'fight back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.3},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.2},
				],
			},
			{
				'type': 'allow it',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -500},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.2},
				],
			},
		]
	},
#	Constants.EVENT_SABOTAGE_FAMILY_1_FOR_FAMILY_2: {
#		'options': [
#
#		]
#	},
#	Constants.EVENT_SABOTAGE_FAMILY_2_FOR_FAMILY_1: {
#		'options': [
#
#		]
#	},
#	Constants.EVENT_STAND_UP_TO_FAMILY_1: {
#		'options': [
#
#		]
#	},
#	Constants.EVENT_STAND_UP_TO_FAMILY_2: {
#		'options': [
#
#		]
#	},
#	Constants.EVENT_STAND_UP_TO_STREET_GANG: {
#		'options': [
#
#		]
#	},
	Constants.EVENT_TAKE_THE_FALL_FOR_FAMILY_1: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
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
	Constants.EVENT_TAKE_THE_FALL_FOR_FAMILY_2: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.2}
				],
				'trigger': Constants.TRIGGER_ARRESTED,
			},
			{
				'type': 'deny',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.4}
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
	Constants.TRIGGER_APPROACHED_BY_BANK_FOR_LOAN: {
		'condition': 'return p.money < 10000',
		'outcomes': [
			{
				'action': 'get loan from bank',
				'chance': 0.6,
				'event': Constants.EVENT_BANK_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_FOR_LOAN: {
		'condition': 'return p.money < 10000 and p.family_1_respect >= 0',
		'outcomes': [
			{
				'action': 'get loan from family_1',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_FOR_LOAN: {
		'condition': 'return p.money < 10000 and p.family_2_respect >= 0',
		'outcomes': [
			{
				'action': 'get loan from family_2',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_TO_ROB_FROM_JOB: {
		'condition': 'return not p.job.is_empty() and p.family_1_respect > 0',
		'outcomes': [
			{
				'action': 'help family_1 rob from job',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_TO_ROB_FROM_JOB: {
		'condition': 'return not p.job.is_empty() and p.family_2_respect > 0',
		'outcomes': [
			{
				'action': 'help family_2 rob from job',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_TO_WORK: {
		'condition': 'return p.family_1_respect >= 0 and p.street_smart > 0.2',
		'outcomes': [
			{
				'action': 'work for family_1',
				'chance': 0.6,
				'event': Constants.EVENT_FAMILY_1_OFFERS_WORK,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_TO_WORK: {
		'condition': 'return p.family_2_respect >= 0 and p.street_smart > 0.2',
		'outcomes': [
			{
				'action': 'work for family_2',
				'chance': 0.6,
				'event': Constants.EVENT_FAMILY_2_OFFERS_WORK,
			},
		]
	},
	Constants.TRIGGER_BRIBE_JURY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					'return p.family_1_respect * 0.1',
					'return p.family_2_respect * 0.1',
				],
				'stat_requirements': [
					'return p.money > (50000 / (1 - clampf(p.heat, 0.01, 0.99)))',
					'return p.street_smart > 0.3',
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
	Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_1: {
		'condition': 'return p.family_1_respect < 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'event': Constants.EVENT_HIT_ATTEMPTED_BY_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_2: {
		'condition': 'return p.family_2_respect < 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'event': Constants.EVENT_HIT_ATTEMPTED_BY_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_IRS_WANTS_PROOF_OF_INCOME: {
		'condition': 'return p.money > 10000 and (p.family_1_respect >= 0.5 or p.family_2_respect >= 0.5)',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'event': Constants.EVENT_FEDS_WANT_PROOF_OF_INCOME,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_EXTORT_BUSINESS: {
		'condition': 'return p.businesses.size() > 0 and p.family_1_respect < 0.2',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.65,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_EXTORT_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_EXTORT_BUSINESS: {
		'condition': 'return p.businesses.size() > 0 and p.family_2_respect < 0.2',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.65,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_EXTORT_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'condition': 'return p.businesses.size() > 0 and p.family_1_respect > 0.2',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'condition': 'return p.businesses.size() > 0 and p.family_2_respect > 0.2',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'condition': 'return p.businesses.size() > 0 and p.family_1_respect > 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'condition': 'return p.businesses.size() > 0 and p.family_2_respect > 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
			},
		]
	},
	Constants.TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_1: {
		'condition': 'return p.family_1_respect > 0.3',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.6,
				'event': Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_2: {
		'condition': 'return p.family_2_respect > 0.3',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.6,
				'event': Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_FAMILY_1: {
		'condition': 'return p.family_1_respect <= 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'event': Constants.EVENT_ROBBED_BY_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_FAMILY_2: {
		'condition': 'return p.family_2_respect <= 0',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'event': Constants.EVENT_ROBBED_BY_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_STREET_GANG: {
		'condition': 'return true',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.3,
				'event': Constants.EVENT_ROBBED_BY_STREET_GANG,
			},
		]
	},
	Constants.TRIGGER_SABOTAGE_FAMILY_1_FOR_FAMILY_2: {
		'condition': 'return p.family_2_respect > 0.5',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.6,
				'event': Constants.EVENT_SABOTAGE_FAMILY_1_FOR_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_SABOTAGE_FAMILY_2_FOR_FAMILY_1: {
		'condition': 'return p.family_1_respect > 0.5',
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.6,
				'event': Constants.EVENT_SABOTAGE_FAMILY_2_FOR_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_SERVE_JAIL_TIME: {
		'condition': null,
		'outcomes': [
			{
				'action': 'served time',
				'chance': 1,
				'stat_updates': [
					{'name': Constants.PLAYER_STREET_SMART, 'value': 'return clampf(0.2, p.heat, p.heat) * 0.5'},
					{'name': Constants.PLAYER_RENTALS, 'value': 'p.rentals = p.rentals.duplicate().slice(0, clampi(2 - ceili(p.heat * 10), -p.rentals.size(), 0)) if p.rentals.size() > 0 and p.heat > 0.4 else p.rentals; return false'},
					{'name': Constants.PLAYER_BUSINESSES, 'value': 'p[Constants.PLAYER_BUSINESSES] = [] if p.heat >= 0.2 else p.businesses; return false'},
				]
			}
		]
	},
	Constants.TRIGGER_THREATEN_JURY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					'return p.family_1_respect * 0.1',
					'return p.family_2_respect * 0.1',
				],
				'stat_requirements': [
					'return p.family_1_respect > 0.5 or p.family_2_respect > 0.5',
					'return p.street_smart > 0.3',
				],
				'stat_updates': [
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
	Constants.TRIGGER_WORKING_FOR_FAMILY_1: {
		'condition': 'return p.family_1_respect > 0.4',
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 0.5,
				'event': Constants.EVENT_HANDLE_GETTING_ARRESTED,
			}
		]
	},
	Constants.TRIGGER_WORKING_FOR_FAMILY_2: {
		'condition': 'return p.family_2_respect > 0.4',
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 0.5,
				'event': Constants.EVENT_HANDLE_GETTING_ARRESTED,
			}
		]
	},
}
