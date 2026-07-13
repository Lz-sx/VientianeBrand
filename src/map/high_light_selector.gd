extends  HighLightLine
class_name HighLightSelector

@export var map:Map
@onready var label1: Label = $Label1

var last_tile:Vector2i = Vector2i(0,0)

func _process(delta: float) -> void:
	if not map:
		print("错误：game_area引用")
		return
	
	var current_tile = map.get_hovered_tile()
	
	if current_tile != last_tile:
		last_tile = current_tile
		var tile_position = map.get_global_from_tile(current_tile)
		position = tile_position
		_update_labels(current_tile)

func _update_labels(tile_position:Vector2i)->void:
	if not label1:
		print("错误：label1引用")
		return
	label1.text = "(%d,%d)" % [tile_position.x,tile_position.y]	
