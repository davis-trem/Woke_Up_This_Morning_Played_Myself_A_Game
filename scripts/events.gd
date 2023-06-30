extends Node

class_name Events

const Player = preload('res://scripts/player.gd')

enum EVENT_TYPE {
	BANK_OFFERS_LOAN,
	FAMILY_1_OFFERS_LOAN,
	FAMILY_1_OFFERS_WORK,
	FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB,
	FAMILY_1_WANTS_TO_EXTORT_BUSINESS,
	FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
	FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
	FAMILY_2_OFFERS_LOAN,
	FAMILY_2_OFFERS_WORK,
	FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB,
	FAMILY_2_WANTS_TO_EXTORT_BUSINESS,
	FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS,
	FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME,
	FEDS_WANT_PROOF_OF_INCOME,
	HANDLE_GETTING_ARRESTED,
	HIT_ATTEMPTED_BY_FAMILY_1,
	HIT_ATTEMPTED_BY_FAMILY_2,
	PROVIDE_INFO_ON_FAMILY_TO_POLICE,
	ROBBED_BY_FAMILY_1,
	ROBBED_BY_FAMILY_2,
	ROBBED_BY_STREET_GANG,
	SABOTAGE_RIVAL_FAMILY,
	STAND_UP_TO_FAMILY_1,
	STAND_UP_TO_FAMILY_2,
	STAND_UP_TO_STREET_GANG,
	TAKE_THE_FALL_FOR_FAMILY_1,
	TAKE_THE_FALL_FOR_FAMILY_2,
}

enum TRIGGER_TYPE {
	ARRESTED,
	BRIBE_JURY,
	SERVE_JAIL_TIME,
	THREATEN_JURY,
	WORKING_FOR_FAMILY_1,
}

var events = {
	EVENT_TYPE.HANDLE_GETTING_ARRESTED: {
		'options': [
			{
				'type': 'bride',
				'trigger': TRIGGER_TYPE.BRIBE_JURY,
			},
			{
				'type': 'threaten',
				'trigger': TRIGGER_TYPE.THREATEN_JURY,
			},
			{
				'type': 'serve',
				'trigger': TRIGGER_TYPE.SERVE_JAIL_TIME,
			},
		],
	},
	EVENT_TYPE.TAKE_THE_FALL_FOR_FAMILY_1: {
		'options': [
			{
				'type': 'accept',
				'stats': [
					{'name': Player.STAT_TYPE.FAMILY_1_RESPECT, 'value': 0.2}
				],
				'trigger': TRIGGER_TYPE.ARRESTED,
			},
			{
				'type': 'deny',
				'stat_updates': [
					{'name': Player.STAT_TYPE.FAMILY_1_RESPECT, 'value': -0.4}
				],
			},
		],
	},
}

var triggers = {
	TRIGGER_TYPE.ARRESTED: {
		'condition': func (stat): return,
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 1,
				'event': EVENT_TYPE.HANDLE_GETTING_ARRESTED,
			}
		]
	},
	TRIGGER_TYPE.BRIBE_JURY: {
		'condition': func (stat): return,
		'outcomes': [
			{
				'action': 'succeed',
				'chance': 0.5,
				'chance_multiplers': [
					func (stat): return stat.family_1_resepect * 0.1,
					func (stat): return stat.family_2_resepect * 0.1,
				],
				'stat_requirement': [
					func (stat): return stat.money > (50000 / (1 - clampf(stat.get(Player.STAT_TYPE.HEAT), 0.01, 0.99))),
					func (stat): return stat.street_smarts > 0.3,
				],
				'stat_updates': [
					{'name': Player.STAT_TYPE.MONEY, 'value': func (stat): return -(50000 / (1 - clampf(stat.get(Player.STAT_TYPE.HEAT), 0.01, 0.99)))},
					{'name': Player.STAT_TYPE.HEAT, 'value': 0.1},
				],
			},
			{
				'action': 'denied',
				'chance': 0.5,
				'trigger': TRIGGER_TYPE.SERVE_JAIL_TIME,
			}
		]
	},
	TRIGGER_TYPE.SERVE_JAIL_TIME: {
		'condition': func (stat): return,
		'outcomes': [
			{
				'action': 'served time',
				'chance': 1,
				'stat_updates': [
					{'name': Player.STAT_TYPE.STREET_SMART, 'value': func (stat): return stat.get(Player.STAT_TYPE.HEAT) * 0.5},
					{'name': Player.STAT_TYPE.RENTALS, 'value': func (stat): stat[Player.STAT_TYPE.RENTALS] = stat.get(Player.STAT_TYPE.RENTALS).duplicate().slice(0, clampi(2 - ceili(stat.get(Player.STAT_TYPE.HEAT) * 10), -stat.get(Player.STAT_TYPE.RENTALS).size(), 0)) if stat.get(Player.STAT_TYPE.RENTALS, []).size() > 0 and stat.get(Player.STAT_TYPE.HEAT) > 0.4 else stat.get(Player.STAT_TYPE.RENTALS, []); return false},
					{'name': Player.STAT_TYPE.BUSINESSES, 'value': func (stat): stat[Player.STAT_TYPE.BUSINESSES] = [] if stat.get(Player.STAT_TYPE.HEAT) >= 0.2 else stat.get(Player.STAT_TYPE.BUSINESSES); return false}
				]
			}
		]
	},
	TRIGGER_TYPE.WORKING_FOR_FAMILY_1: {
		'condition': func (stat): return,
		'outcomes': [
			{
				'action': 'handle arrested',
				'chance': 1,
				'event': EVENT_TYPE.HANDLE_GETTING_ARRESTED,
			}
		]
	},
}


func trigger_event(player: Player, trigger_type):
	var applicable_outcomes = [];
	if trigger_type != null:
		applicable_outcomes = triggers[trigger_type].get('outcomes')
	else:
		for type in triggers:
			if triggers[type].call(player.stats):
				applicable_outcomes.append_array(triggers[type].get('outcomes'))
	
	var outcomes = _calculate_outcomes_accumulated_chance(applicable_outcomes, player.stats)
	var chance = randf_range(0, outcomes[outcomes.size() - 1].get('accumulated_chance'))
	for outcome in outcomes:
		if outcome.get('accumulated_chance') > chance:
			for stat_update in outcome.get('stat_updates', []):
				var update_value = (
					stat_update.get('value').call(player.stats) 
					if typeof(stat_update.get('value')) == TYPE_CALLABLE 
					else stat_update.get('value')
				)
				if not (typeof(update_value) == TYPE_BOOL and update_value == false):
					player.stats[stat_update.get('name')] += update_value
		if outcome.get('trigger'):
			trigger_event(player.stats, outcome.get('trigger'))
		elif outcome.get('event'):
			# Present Event
			pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _calculate_outcomes_accumulated_chance(outcomes: Array, stats) -> Array:
	var outcomes_accumulated_chance = []
	var accumulated_chance = 0
	for outcome in outcomes:
		for chance_multiplers in outcome.get('chance_multiplers', []):
			accumulated_chance += chance_multiplers.call(stats)
		outcomes_accumulated_chance.append(outcome)
		outcomes_accumulated_chance[outcomes_accumulated_chance.size() - 1]['accumulated_chance'] = accumulated_chance + outcome.get('chance')
	return outcomes_accumulated_chance
