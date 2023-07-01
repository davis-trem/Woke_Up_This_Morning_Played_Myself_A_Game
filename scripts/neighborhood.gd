class_name Neighborhood
extends ColorRect


const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')

@onready var name_label = $Name
@onready var status_label = $Status

var stats: NeighborhoodStats
var initial_status_label_text = ''

var _input_handler: Callable = func (event, n): return


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = stats.name
	status_label.text = initial_status_label_text


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

