extends Node

class_name Player

enum STAT_TYPE {
	BUSINESSES,
	FAMILY_1_RESPECT,
	FAMILY_2_RESPECT,
	HEAT,
	INCOME,
	JOB,
	LOANS,
	MONEY,
	RENTALS,
	SANITY,
	STREET_SMART,
	TERRITORIES_RESPECT,
}

var stats = {
	STAT_TYPE.BUSINESSES: [],
	STAT_TYPE.FAMILY_1_RESPECT: 0,
	STAT_TYPE.FAMILY_2_RESPECT: 0,
	STAT_TYPE.HEAT: 0,
	STAT_TYPE.INCOME: 0,
	STAT_TYPE.JOB: null,
	STAT_TYPE.LOANS: [],
	STAT_TYPE.MONEY: 0,
	STAT_TYPE.RENTALS: [],
	STAT_TYPE.SANITY: 1,
	STAT_TYPE.STREET_SMART: 0,
	STAT_TYPE.TERRITORIES_RESPECT: [],
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
