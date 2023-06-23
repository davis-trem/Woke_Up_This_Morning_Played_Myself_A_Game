extends Node2D

@export var territory_count: int = 9
var territories = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _init_territories():
	var family_count = territory_count / 3
	for i in range(territory_count):
		territories.append({
			'business_model': {
				'cost_to_start': 0,
				'cost_to_run': 0,
				'payout': 0,
			},
			'family_1_ownership': 0,
			'family_2_ownership': 0,
			'rent': 0,
		})
