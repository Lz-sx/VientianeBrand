extends Control

const ONLINE_LOBBY = preload("uid://b4742gyg2flia")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_online_lobby_button_pressed() -> void:
	get_tree().change_scene_to_packed(ONLINE_LOBBY)
