extends Control
class_name CardBaseOnhand

@onready var texture_button: Panel = $TextureButton

var tween:Tween
var is_ready:bool = false

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	is_ready = true

func _on_mouse_entered() -> void:
	if not is_ready:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(texture_button,"position",Vector2(0,-8),0.1)

func _on_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(texture_button,"position",Vector2(0,0),0.1)
