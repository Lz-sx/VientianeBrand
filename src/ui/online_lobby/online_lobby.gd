extends Control
const MAIN_GAME = preload("uid://tdb8d8mdvj61")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_GAME)


func _on_host_button_pressed() -> void:
	LanNetwork.create_game()


func _on_join_button_pressed() -> void:
	LanNetwork.join_game()
