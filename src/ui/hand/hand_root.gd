extends Control
class_name HandRoot
@export var offset_y:int = 100
@onready var data: Data = $"../../Data"
const CARD_BASE_ONHAND = preload("uid://va7mf6bcwcax")

var base_position = Vector2(DisplayServer.window_get_size().x/2.0, DisplayServer.window_get_size().y - offset_y)
var card_size:int = 0

func add_card():
	var new_card = CARD_BASE_ONHAND.instantiate()
	new_card.setup(data)
	add_child(new_card)
	card_size+=1
	await get_tree().create_timer(0.1).timeout
	move()

func move():
	var center_num = 0
	if card_size%2 != 0:
		center_num = (card_size-1)/2
		for i in card_size:
			var card = get_child(i)
			var angle = (i - center_num) * 2
			var offset = Vector2(sin(deg_to_rad(angle+90)) * angle * 25, cos(deg_to_rad(angle+90)) * angle * 15)
			var target_position = base_position - card.size/2 + offset
			var tween:Tween = create_tween()
			tween.tween_property(card,"global_position",target_position,0.1)
			tween.parallel().tween_property(card,"rotation_degrees", angle, 0.1)
	else:
		center_num = card_size/2
		for i in card_size:
			var card = get_child(i)
			var angle = (i-center_num)*2 + 1
			var offset = Vector2(sin(deg_to_rad(angle+90)) * angle * 25, - cos(deg_to_rad(angle+90)) * angle * 15)
			var target_position = base_position - card.size/2 + offset
			var tween:Tween = create_tween()
			tween.tween_property(card,"global_position",target_position,0.1)
			tween.parallel().tween_property(card,"rotation_degrees", angle, 0.1)

func _ready() -> void:
	add_card()
	add_card()
	add_card()
	add_card()
	add_card()
	add_card()
