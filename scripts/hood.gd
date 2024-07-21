extends TextureButton

@onready var name_label: Label = $CenterContainer/VBoxContainer/NameLabel
@onready var rented_icon: TextureRect = $CenterContainer/VBoxContainer/HBoxContainer/rentedIcon
@onready var job_icon: TextureRect = $CenterContainer/VBoxContainer/HBoxContainer/jobIcon
@onready var company_icon: TextureRect = $CenterContainer/VBoxContainer/HBoxContainer/companyIcon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
