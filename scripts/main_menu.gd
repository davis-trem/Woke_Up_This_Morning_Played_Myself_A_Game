extends Control

const game_map_scene = preload('res://screens/game_map.tscn')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start_game(start_new_game: bool):
	var game_map = game_map_scene.instantiate()
	game_map.start_new_game = start_new_game
	get_tree().root.add_child(game_map)
	queue_free()


func _on_new_game_button_pressed():
	start_game(true)


func _on_resume_button_pressed():
	start_game(false)
