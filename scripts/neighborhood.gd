class_name Neighborhood
extends Button


const NeighborhoodStats = preload('res://resources/neighborhood_stats.gd')

@onready var name_label = $Name
@onready var status_label = $Status

var stats: NeighborhoodStats
var initial_status_label_text = ''


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = stats.name
	status_label.text = initial_status_label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



