extends Control
class_name CardBaseOnhand

@onready var texture_button: TextureButton = $TextureButton
@onready var line_2d: Line2D = $TextureButton/Line2D

@export var id:int
@export var Affiliation:Data.Affiliation
@export var Type:Data.Type

var tween:Tween
var is_ready:bool = false

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	is_ready = true

func _on_texture_button_mouse_entered() -> void:
	if not is_ready:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(texture_button,"position",Vector2(0,-8),0.1)


func _on_texture_button_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(texture_button,"position",Vector2(0,0),0.1)


func selected() -> void:
	line_2d.visible = true
	
func deselect() -> void:
	line_2d.visible = false
