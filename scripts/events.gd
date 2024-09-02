class_name Events
extends Node

const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')
const Player = preload('res://resources/player.gd')
const Constants = preload('res://scripts/constants.gd')

#events = {
#	[name]: {
#		options: {
#			type: string,
#			stat_updates?: {
#				name: string, value: number | (player, neighborhoods) => number | false
#			}[],
#			trigger?: string,
#		}[]
#	}
#}

#triggers = {
#	[name]: {
#		condition: null | (player, neighborhoods) => bool,
#		outcomes: {
#			action: string,
#			chance: float,
#			event?: string,
#			trigger?: string,
#			chance_multiplers?: ((player, neighborhoods) => float)[],
#			stat_requirements?: ((player, neighborhoods) => bool)[],
#			stat_updates?: {
#				name: string, value: number | (player, neighborhoods) => number | false
#			}[],
#		}[]
#	}
#}

static var events := {
	Constants.EVENT_BANK_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 15000},
					{
						'name': Constants.PLAYER_LOANS,
						'value': func (p: Player, n: Array[NeighborhoodStats]): p.loans.append({'by': Constants.BANK, 'rate': snappedf(Constants.LOAN_RATE_LIMITS[Constants.BANK].min, Constants.LOAN_RATE_LIMITS[Constants.BANK].max), 'owed': 15000}); return false
					},
				]
			},
			{
				'type': 'decline',
			}
		]
	},
	Constants.EVENT_EMPLOYEES_WANT_TO_UNIONIZE: {
		'options': [
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.pick_random().get('hood_index'); n[hi].business_payout -= randi_range(ceili(n[hi].business_payout/4), ceili(n[hi].business_payout/2)); return false},
				],
			},
			{
				'type': 'deny',
				'trigger': Constants.TRIGGER_DENY_EMPLOYEES_UNION,
			}
		]
	},
	Constants.EVENT_FAMILY_1_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 5000},
					{
						'name': Constants.PLAYER_LOANS,
						'value': func (p: Player, n: Array[NeighborhoodStats]): p.loans.append({'by': Constants.FAM_1, 'rate': snappedf(Constants.LOAN_RATE_LIMITS[Constants.FAM_1].min, Constants.LOAN_RATE_LIMITS[Constants.FAM_1].max), 'owed': 5000}); return false
					},
				]
			},
			{
				'type': 'decline',
				'trigger': Constants.TRIGGER_DECLINED_LOAN_FROM_FAMILY_1,
			}
		]
	},
	Constants.EVENT_FAMILY_2_OFFERS_LOAN: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 10000},
					{
						'name': Constants.PLAYER_LOANS,
						'value': func (p: Player, n: Array[NeighborhoodStats]): p.loans.append({'by': Constants.FAM_2, 'rate': snappedf(Constants.LOAN_RATE_LIMITS[Constants.FAM_2].min, Constants.LOAN_RATE_LIMITS[Constants.FAM_2].max), 'owed': 10000}); return false
					},
				]
			},
			{
				'type': 'decline',
				'trigger': Constants.TRIGGER_DECLINED_LOAN_FROM_FAMILY_2,
			}
		]
	},
	Constants.EVENT_FAMILY_1_OFFERS_WORK: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 1000},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.1},
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
	Constants.EVENT_FAMILY_2_OFFERS_WORK: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': 600},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.1},
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
	Constants.EVENT_FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.2}
				],
				'trigger': Constants.TRIGGER_ROB_FROM_JOB,
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.5}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.2}
				],
				'trigger': Constants.TRIGGER_ROB_FROM_JOB,
			},
			{
				'type': 'decline',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3}
				]
			}
		]
	},
	Constants.EVENT_FAMILY_1_WANTS_TO_EXTORT_BUSINESS: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var biz = p.businesses.reduce(func(t, b): return b if t == -1 and not b.has('extortion') and n[b.get('hood_index')].family_1_ownership > 0 else t, -1); var rate = snappedf(randf_range(Constants.EXTORTION_RATE_LIMITS['fam_1']['min'], Constants.EXTORTION_RATE_LIMITS['fam_1']['max']), 0.01); biz['extortion'] = {'by':'fam_1', 'rate':rate, 'owed':0}; return false}
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
	Constants.EVENT_FAMILY_2_WANTS_TO_EXTORT_BUSINESS: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var biz = p.businesses.reduce(func(t, b): return b if t == -1 and not b.has('extortion') and n[b.get('hood_index')].family_2_ownership > 0 else t, -1); var rate = snappedf(randf_range(Constants.EXTORTION_RATE_LIMITS['fam_2']['min'], Constants.EXTORTION_RATE_LIMITS['fam_2']['max']), 0.01); biz['extortion'] = {'by':'fam_2', 'rate':rate, 'owed':0}; return false}
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
	Constants.EVENT_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var biz = p.businesses.reduce(func(t, b): return b if t == -1 and not b.has('laundering') and n[b.get('hood_index')].family_1_ownership > 0 else t, -1); var rate = snappedf(randf_range(Constants.EXTORTION_RATE_LIMITS['fam_1']['min'], Constants.EXTORTION_RATE_LIMITS['fam_1']['max']), 0.01); biz['laundering'] = {'by':'fam_1', 'rate':rate}; return false},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.1},
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
	Constants.EVENT_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var biz = p.businesses.reduce(func(t, b): return b if t == -1 and not b.has('laundering') and n[b.get('hood_index')].family_2_ownership > 0 else t, -1); var rate = snappedf(randf_range(Constants.EXTORTION_RATE_LIMITS['fam_2']['min'], Constants.EXTORTION_RATE_LIMITS['fam_2']['max']), 0.01); biz['laundering'] = {'by':'fam_2', 'rate':rate}; return false},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.1},
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
				],
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
	Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_1: {
		'options': [
			{
				'type': 'accept',
				'stat_updates': [
					{'name': Constants.PLAYER_HEAT, 'value': -0.4},
				],
				'trigger': Constants.TRIGGER_FAMILY_1_SUSPECTS_RAT,
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
					{'name': Constants.PLAYER_HEAT, 'value': -0.4},
				],
				'trigger': Constants.TRIGGER_FAMILY_1_SUSPECTS_RAT,
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
	Constants.EVENT_FEDS_WANT_PROOF_OF_INCOME: {
		'options': [
			{
				'type': 'accept',
				'trigger': Constants.TRIGGER_IRS_INVESTIGATES_PROOF_OF_INCOME,
			},
			{
				'type': 'decline',
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
	Constants.EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_1: {
		'options': [
			{
				'type': 'fight_back',
				'trigger': Constants.TRIGGER_FIGHT_OFF_FAMILY_1_HIT,
			},
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.1},
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
			{
				'type': 'run',
				'trigger': Constants.TRIGGER_RUN_FROM_HIT_BY_FAMILY_1,
			},
		]
	},
	Constants.EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_2: {
		'options': [
			{
				'type': 'fight_back',
				'trigger': Constants.TRIGGER_FIGHT_OFF_FAMILY_2_HIT,
			},
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.1},
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
			{
				'type': 'run',
				'trigger': Constants.TRIGGER_RUN_FROM_HIT_BY_FAMILY_2,
			},
		]
	},
	Constants.EVENT_ROBBED_BY_FAMILY_1: {
		'options': [
			{
				'type': 'fight_back',
				'trigger': Constants.TRIGGER_FIGHT_OFF_FAMILY_1_HIT,
			},
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -1000},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.2},
				],
			},
			{
				'type': 'run',
				'trigger': Constants.TRIGGER_RUN_FROM_FAMILY_1_ROBBERY,
			},
		]
	},
	Constants.EVENT_ROBBED_BY_FAMILY_2: {
		'options': [
			{
				'type': 'fight_back',
				'trigger': Constants.TRIGGER_FIGHT_OFF_FAMILY_2_HIT,
			},
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -2000},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.2},
				],
			},
			{
				'type': 'run',
				'trigger': Constants.TRIGGER_RUN_FROM_FAMILY_2_ROBBERY,
			},
		]
	},
	Constants.EVENT_ROBBED_BY_STREET_GANG: {
		'options': [
			{
				'type': 'fight_back',
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.2},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.1},
					{'name': Constants.PLAYER_STREET_SMART, 'value': 0.1},
				],
			},
			{
				'type': 'allow',
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': -500},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.2},
					{'name': Constants.PLAYER_STREET_SMART, 'value': -0.2},
				],
			},
			{
				'type': 'run',
				'trigger': Constants.TRIGGER_RUN_FROM_STREET_GANG_ROBBERY,
			},
		]
	},
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

static var triggers := {
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
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.money < 10000 and p.heat < 0.4,
		'outcomes': [
			{
				'action': 'get loan from bank',
				'chance': 0.6,
				'event': Constants.EVENT_BANK_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_FOR_LOAN: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.money < 10000 and p.family_1_respect >= 0,
		'outcomes': [
			{
				'action': 'get loan from family_1',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_FOR_LOAN: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.money < 10000 and p.family_2_respect >= 0,
		'outcomes': [
			{
				'action': 'get loan from family_2',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_OFFERS_LOAN,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_TO_ROB_FROM_JOB: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.job != -1 and p.family_1_respect > 0,
		'outcomes': [
			{
				'action': 'help family_1 rob from job',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_TO_ROB_FROM_JOB: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.job != -1 and p.family_2_respect > 0,
		'outcomes': [
			{
				'action': 'help family_2 rob from job',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_1_TO_WORK: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect >= 0 and p.street_smart > 0.2,
		'outcomes': [
			{
				'action': 'work for family_1',
				'chance': 0.6,
				'event': Constants.EVENT_FAMILY_1_OFFERS_WORK,
			},
		]
	},
	Constants.TRIGGER_APPROACHED_BY_FAMILY_2_TO_WORK: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect >= 0 and p.street_smart > 0.2,
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
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect * 0.1,
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect * 0.1,
				],
				'stat_requirements': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.money > (50000 / (1 - clampf(p.heat, 0.01, 0.99))),
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart > 0.3,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': func (p: Player, n: Array[NeighborhoodStats]): return -(50000 / (1 - clampf(p.heat, 0.01, 0.99)))},
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
	Constants.TRIGGER_DECLINED_LOAN_FROM_FAMILY_1: {
		'condition': null,
		'outcomes': [
			{
				'action': 'hit',
				'chance': 0.5,
				'trigger': Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_1,
			},
			{
				'action': 'sabotage',
				'chance': 0.5,
				'trigger': Constants.TRIGGER_FAMILY_1_SABOTAGE_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_DECLINED_LOAN_FROM_FAMILY_2: {
		'condition': null,
		'outcomes': [
			{
				'action': 'hit',
				'chance': 0.5,
				'trigger': Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_2,
			},
			{
				'action': 'sabotage',
				'chance': 0.5,
				'trigger': Constants.TRIGGER_FAMILY_2_SABOTAGE_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_DENY_EMPLOYEES_UNION: {
		'condition': null,
		'outcomes': [
			{
				'action': 'suceed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.pick_random().get('hood_index'); p.territories_respect[hi] -= 0.3; return false},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.pick_random().get('hood_index'); n[hi].business_payout -= randi_range(ceili(n[hi].business_payout/4), ceili(n[hi].business_payout/2)); return false},
				],
			},
		]
	},
	Constants.TRIGGER_EMPLOYEES_WANT_TO_UNIONIZE: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.businesses.size() > 0,
		'outcomes': [
			{
				'action': 'suceed',
				'chance': 0.5,
				'event': Constants.EVENT_EMPLOYEES_WANT_TO_UNIONIZE,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_OFFERS_WORK: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): p.family_1_respect >= 0 and p.rentals.reduce(func(t, hi): return hi if t == -1 and n[hi].family_1_ownership > 0 else t, -1) != -1,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.45,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.2,
				],
				'event': Constants.EVENT_FAMILY_1_OFFERS_WORK,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_OFFERS_WORK: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): p.family_2_respect >= 0 and p.rentals.reduce(func(t, hi): return hi if t == -1 and n[hi].family_2_ownership > 0 else t, -1) != -1,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.45,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.2,
				],
				'event': Constants.EVENT_FAMILY_2_OFFERS_WORK,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_EXTORT_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and not b.has('extortion') and n[b.get('hood_index')].family_1_ownership > 0 else t, -1); return hi != -1 and p.family_1_respect < 0.5,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.65,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_EXTORT_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_EXTORT_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and not b.has('extortion') and n[b.get('hood_index')].family_2_ownership > 0 else t, -1); return hi != -1 and p.family_2_respect < 0.5,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.65,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_EXTORT_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and not b.has('laundering') and n[b.get('hood_index')].family_1_ownership > 0 else t, -1); return hi != -1 and p.family_1_respect > 0.2,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and not b.has('laundering') and n[b.get('hood_index')].family_2_ownership > 0 else t, -1); return hi != -1 and p.family_2_respect > 0.2,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and n[b.get('hood_index')].family_1_ownership > 0 else t, -1); return hi != -1 and p.family_1_respect > 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.35,
				'event': Constants.EVENT_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): var hi = p.businesses.reduce(func(t, b): return b.get('hood_index') if t == -1 and n[b.get('hood_index')].family_2_ownership > 0 else t, -1); return hi != -1 and p.family_2_respect > 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.35,
				'event': Constants.EVENT_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_SABOTAGE_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): p.businesses.size() > 0 and p.family_1_respect < 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.35,
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var bi = randi_range(0, p.businesses.size()); p.businesses.pop_at(bi); return false},
				],
			},
			{
				'action': 'prevent',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
				],
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_SABOTAGE_BUSINESS: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): p.businesses.size() > 0 and p.family_2_respect < 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.35,
				'stat_updates': [
					{'name': Constants.PLAYER_BUSINESSES, 'value': func (p: Player, n: Array[NeighborhoodStats]): var bi = randi_range(0, p.businesses.size()); p.businesses.pop_at(bi); return false},
				],
			},
			{
				'action': 'prevent',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
				],
			},
		]
	},
	Constants.TRIGGER_FAMILY_1_SUSPECTS_RAT: {
		'condition': null,
		'outcomes': [
			{
				'action': 'found_you',
				'chance': 0.6,
				'trigger': Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_1,
			},
			{
				'action': 'found_nothing',
				'chance': 0.4,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.1},
				],
			},
		]
	},
	Constants.TRIGGER_FAMILY_2_SUSPECTS_RAT: {
		'condition': null,
		'outcomes': [
			{
				'action': 'found_you',
				'chance': 0.6,
				'trigger': Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_2,
			},
			{
				'action': 'found_nothing',
				'chance': 0.4,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.1},
				],
			},
		]
	},
	Constants.TRIGGER_FIGHT_OFF_FAMILY_1_HIT: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.1,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': 0.1},
				],
			},
			{
				'action': 'failed',
				'chance': 0.6,
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.2},
				],
			},
		]
	},
	Constants.TRIGGER_FIGHT_OFF_FAMILY_2_HIT: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.1,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': 0.1},
				],
			},
			{
				'action': 'failed',
				'chance': 0.6,
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.2},
				],
			},
		]
	},
	Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_1: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect < 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
			{
				'action': 'noticed',
				'chance': 0.3,
				'event': Constants.EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_HIT_ATTEMPT_BY_FAMILY_2: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect < 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'stat_updates': [
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
			{
				'action': 'noticed',
				'chance': 0.3,
				'event': Constants.EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_IRS_INVESTIGATES_PROOF_OF_INCOME: {
		'condition': null,
		'outcomes': [
			{
				'action': 'found_crime',
				'chance': 0.65,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.heat * 0.1,
				],
				'trigger': Constants.TRIGGER_ARRESTED,
			},
			{
				'action': 'find_nothing',
				'chance': 0.35,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.1,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_HEAT, 'value': -0.1},
				],
			},
		]
	},
	Constants.TRIGGER_IRS_WANTS_PROOF_OF_INCOME: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.money > 10000 and (p.family_1_respect >= 0.5 or p.family_2_respect >= 0.5 or p.heat >= 0.5),
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.7,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect * 0.1,
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect * 0.1,
					func (p: Player, n: Array[NeighborhoodStats]): return p.heat * 0.1,
				],
				'event': Constants.EVENT_FEDS_WANT_PROOF_OF_INCOME,
			},
		]
	},
	Constants.TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_1: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect >= 0.3,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect * 0.2,
				],
				'event': Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_2: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect >= 0.3,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect * 0.2,
				],
				'event': Constants.EVENT_FEDS_WANTS_INFO_ON_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_FAMILY_1: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect <= 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect * 0.2,
				],
				'event': Constants.EVENT_ROBBED_BY_FAMILY_1,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_FAMILY_2: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect <= 0,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect * 0.2,
				],
				'event': Constants.EVENT_ROBBED_BY_FAMILY_2,
			},
		]
	},
	Constants.TRIGGER_ROBBED_BY_STREET_GANG: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart < 0.4,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.3,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.2,
				],
				'event': Constants.EVENT_ROBBED_BY_STREET_GANG,
			},
		]
	},
	Constants.TRIGGER_ROB_FROM_JOB: {
		'condition': null,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart * 0.1,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_MONEY, 'value': randi_range(500, 2000)},
					{'name': Constants.PLAYER_HEAT, 'value': 0.2},
				]
			},
			{
				'action': 'caught',
				'chance': 0.5,
				'chance_multiplers': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.heat * 0.1,
				],
				'stat_updates': [
					{'name': Constants.PLAYER_JOB, 'value': func (p: Player, n: Array[NeighborhoodStats]): p.job = -1; return false},
				],
				'trigger': Constants.TRIGGER_ARRESTED,
			},
		]
	},
	Constants.TRIGGER_RUN_FROM_FAMILY_1_ROBBERY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'get_away',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_MONEY, 'value': -randi_range(500, 2000)},
				],
			},
		]
	},
	Constants.TRIGGER_RUN_FROM_FAMILY_2_ROBBERY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'get_away',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_MONEY, 'value': -randi_range(500, 2000)},
				],
			},
		]
	},
	Constants.TRIGGER_RUN_FROM_HIT_BY_FAMILY_1: {
		'condition': null,
		'outcomes': [
			{
				'action': 'get_away',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_1_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
		]
	},
	Constants.TRIGGER_RUN_FROM_HIT_BY_FAMILY_2: {
		'condition': null,
		'outcomes': [
			{
				'action': 'get_away',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_FAMILY_2_RESPECT, 'value': -0.3},
					{'name': Constants.PLAYER_SANITY, 'value': -0.3},
				],
			},
		]
	},
	Constants.TRIGGER_RUN_FROM_STREET_GANG_ROBBERY: {
		'condition': null,
		'outcomes': [
			{
				'action': 'get_away',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_STREET_SMART, 'value': -0.3},
				],
			},
			{
				'action': 'failed',
				'chance': 0.5,
				'stat_updates': [
					{'name': Constants.PLAYER_STREET_SMART, 'value': -0.3},
					{'name': Constants.PLAYER_MONEY, 'value': -randi_range(500, 2000)},
				],
			},
		]
	},
	Constants.TRIGGER_SERVE_JAIL_TIME: {
		'condition': null,
		'outcomes': [
			{
				'action': 'serve_time',
				'chance': 1,
				'stat_updates': [
					{'name': Constants.PLAYER_MONTHS_JAILED, 'value': func (p: Player, n: Array[NeighborhoodStats]): var h = p.heat * 10 if p.heat > 0 else 1; return randi_range(ceili(h / 1.5), h)},
				]
			}
		]
	},
	Constants.TRIGGER_TAKE_THE_FALL_FOR_FAMILY_1: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): 0.3 < p.family_1_respect and p.family_1_respect < 0.8,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'event': Constants.EVENT_TAKE_THE_FALL_FOR_FAMILY_1,
			}
		]
	},
	Constants.TRIGGER_TAKE_THE_FALL_FOR_FAMILY_2: {
		'condition': func (p: Player, n: Array[NeighborhoodStats]): 0.3 < p.family_2_respect and p.family_2_respect < 0.8,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.4,
				'event': Constants.EVENT_TAKE_THE_FALL_FOR_FAMILY_2,
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
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect * 0.1,
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_2_respect * 0.1,
				],
				'stat_requirements': [
					func (p: Player, n: Array[NeighborhoodStats]): return p.family_1_respect > 0.5 or p.family_2_respect > 0.5,
					func (p: Player, n: Array[NeighborhoodStats]): return p.street_smart > 0.3,
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
}
