extends  HighLightLine
class_name HighLightSelector

@export var map:Map
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

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
	if not label_1:
		print("错误：label1引用")
		return
	if not label_2:
		print("错误：label2引用")
		return
	if not label_3:
		print("错误：label3引用")
		return
	label_1.text = "(%d,%d)" % [tile_position.x,tile_position.y]	
	if not map.game_grid:
		print("错误：通过map对game_grid引用")
		return
		
	var cell_data = map.game_grid.get_cell_data(tile_position)
	if not cell_data.is_empty():
		var board = cell_data.get("board")
		var obstacle = cell_data.get("obstacle")

		if board != null:
			label_2.text = map.game_grid.get_board_string(board)
		else:
			label_2.text = "unknown"
		if obstacle != null:
			label_3.text = map.game_grid.get_obstacle_string(obstacle)
		else:
			label_3.text = "unknown"	
	else:
		print("错误：cell_data为空")
	
	
