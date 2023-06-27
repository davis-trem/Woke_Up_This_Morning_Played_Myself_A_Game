extends ColorRect

class_name Neighborhood

@onready var name_label = $Name
@onready var status_label = $Status

var stats = {
	'name': '',
	'business_model': {
		'cost_to_start': 0,
		'cost_to_run': 0,
		'payout': 0,
	},
	'family_1_ownership': 0,
	'family_2_ownership': 0,
	'rent': 0,
}

var _input_handler: Callable = func (event, n): return


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = stats.get('name')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventScreenTouch:
		pass
	if (event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
		and (global_position.x < event.position.x and global_position.y < event.position.y)
		and (event.position.x < (global_position + size).x and event.position.y < (global_position + size).y)
	):
		_input_handler.call(event, self)


func set_input_handler(handler: Callable):
	_input_handler = handler


