extends Node
class_name GameGrid

enum Board {LAND=1, RIVER, NULL}
enum Obstacle {ROCK=1, WOOD, NULL}

signal grid_changed

@export var board:TileMapLayer
@export var obstacle:TileMapLayer

var grid_data:Dictionary = {}

func _ready() -> void:
	pass
	
func _init_grid() -> void:
	grid_data.clear()
	if not board:
		print("错误：board引用")
		return
	for cell_position in board.get_used_cells():
		var tile_data = board.get_cell_tile_data(cell_position)
		#默认地形
		var board_type = Board.LAND
		if tile_data:
			var custom_board = tile_data.get_custom_data("Board")
			if typeof(custom_board) == TYPE_INT:
				board_type = custom_board as Board
			else:
				print("错误：棋盘类型返回非int类型")
				return
		grid_data[cell_position]={
			"unit" : null,
			"board" : board_type,
			"obstacle" : Obstacle.NULL
		}
		
	if not obstacle:
		print("错误：obstacle引用")
		return
	for cell_position in obstacle.get_used_cells():
		var tile_data = obstacle.get_cell_tile_data(cell_position)
		#默认地形
		var obstacle_type = Obstacle.ROCK
		if tile_data:
			var custom_obstacle = tile_data.get_custom_data("Obstacle")
			if typeof(custom_obstacle) == TYPE_INT:
				obstacle_type = custom_obstacle as Obstacle
			else:
				print("错误：棋盘类型返回非int类型")
				return
		grid_data[cell_position]["obstacle"] = obstacle_type
		
func get_cell_data(cell_position:Vector2i) -> Dictionary:
	if not grid_data.has(cell_position):
		return {}
	return grid_data[cell_position]
	
func get_all_cell_data() -> Dictionary:
	return grid_data

## 获取地形类型的字符串表示（小写）
func get_board_string(board_val: int) -> String:
	var key = Board.find_key(board_val)
	if key:
		return key.to_lower()
	return "unknown"

## 获取障碍物类型的字符串表示（小写）
func get_obstacle_string(obstacle_val: int) -> String:
	var key = Obstacle.find_key(obstacle_val)
	if key:
		return key.to_lower()
	return "unknown"

#在网格中添加单位
#成功返回true，失败返回false
func add_unit(unit:CardBaseOnmap, cell_position:Vector2i) -> bool:
	if not grid_data.has(cell_position):
		push_warning("错误：没有此网格坐标")
		return false
	if not is_usable(cell_position):
		push_warning("错误：此网格坐标不可用")
		return false
		
	grid_data[cell_position]["unit"] = unit
	grid_changed.emit()
	return true

func is_usable(cell_position:Vector2i) -> bool:
	if not get_cell_data(cell_position) == null:
		return true
	return false

func remove_unit_by_pos(cell_position:Vector2i) -> bool:
	if not grid_data.has(cell_position):
		push_warning("错误：没有此网格坐标")
		return false
	grid_data[cell_position]["unit"] = null
	grid_changed.emit()
	return true

func remove_unit_by_unit(unit:CardBaseOnmap) -> bool:
	if grid_data.find_key(unit) == null:
		return false
	return remove_unit_by_pos(grid_data.find_key(unit))
