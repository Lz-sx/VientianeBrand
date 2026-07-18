extends Node
class_name  GridRange

@export var game_grid: GameGrid

var active_unit_map:Dictionary
var deploy_range:Array[Vector2i]
#位置
var attack_range:Array[Vector2i]
var move_range:Array[Vector2i]
#位置中所有的单位
var units_in_attack:Array[CardBaseOnmap]
var units_in_move:Array[CardBaseOnmap]
#可交互位置和其中单位
var attack_target_map:Dictionary
var occupy_cell_map:Dictionary

func find_active_unit_map():
	for cell_pos in game_grid.grid_data:
		var unit = game_grid.grid_data[cell_pos].get("unit", null)
		if unit != null:
			active_unit_map[cell_pos] = unit

func find_deploy_range(selected_unit_faction:Data.Faction, selected_unit_type:Data.Type):
	deploy_range.clear()
	var temp_set: Dictionary # key存坐标，自动去重
	for cell_pos in active_unit_map:
		var unit = active_unit_map[cell_pos]
		if unit.Faction == selected_unit_faction:
			var cells = get_cells_in_range(cell_pos, unit.deployment_range)
			for pos in cells:
				temp_set[pos] = true
	# 把唯一的key转回数组
	deploy_range = temp_set.keys()
	for pos in active_unit_map:
		find_occupy_cell_map(selected_unit_faction,selected_unit_type,\
		active_unit_map[pos],pos)
	
		
	
func get_cells_in_range(center: Vector2i, range: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []	
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if abs(x) + abs(y) <= range and game_grid.grid_data.has(Vector2i(x,y)):
				cells.append(center + Vector2i(x, y))
	return cells
	
# 四个方向：上下左右
const DIRS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]

func find_move_range(center: Vector2i, selected_unit:CardBaseOnmap, speed: int) -> void:
	move_range.clear()
	units_in_move.clear()
	occupy_cell_map.clear()
	# BFS 队列：存 [坐标, 已走步数]
	var queue: Array = [[center, 0]]
	# 记录已访问的格子，避免重复
	var visited: Dictionary = {center: true}
	while queue.size() > 0:
		var current = queue.pop_front()
		var pos: Vector2i = current[0]
		var steps: int = current[1]
		move_range.append(pos)  # 可达格子加入结果
		# 步数到上限就不再扩展
		if steps >= speed:
			continue
		# 扩展四个方向
		for dir in DIRS:
			var next_pos: Vector2i = pos + dir
			# 已经访问过就跳过
			if visited.has(next_pos):
				continue
			if not game_grid.grid_data.has(next_pos):
				continue
			# 判断障碍物：有单位就不能走
			if game_grid.grid_data[next_pos]["obstacle"] == game_grid.Obstacle.ROCK:
				continue
			if game_grid.grid_data[next_pos]["unit"] != null:
				units_in_move.append(game_grid.grid_data[next_pos]["unit"])
				
				find_occupy_cell_map(selected_unit.Faction,selected_unit.Type,\
				game_grid.grid_data[next_pos]["unit"],next_pos)
				continue
			visited[next_pos] = true
			queue.append([next_pos, steps + 1])

func find_attack_range(center: Vector2i, selected_unit:CardBaseOnmap,range: int):
	attack_range.clear()
	units_in_attack.clear()
	attack_target_map.clear()
	attack_range = get_cells_in_range(center,range)
	for position in attack_range:
		if game_grid.grid_data[position]["unit"] != null:
			units_in_attack.append(game_grid.grid_data[position]["unit"])
			find_attack_target_map(selected_unit,game_grid.grid_data[position]["unit"],position)
			

func find_attack_target_map(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap,\
position:Vector2i):
	if selected_unit.Faction != target_unit.Faction:
		attack_target_map[position]=target_unit
		
func find_occupy_cell_map(selected_unit_faction:Data.Faction,selected_unit_type:Data.Type,\
target_unit:CardBaseOnmap,position:Vector2i):
	if selected_unit_faction == target_unit.Faction:
		if target_unit.Type == Data.Type.VEHICLE:
			target_unit = target_unit as VehicleCardBase
			if target_unit.capacity > 0 and selected_unit_type!=Data.Type.VEHICLE \
			and selected_unit_type!=Data.Type.BUILDING:
				occupy_cell_map[position]=target_unit
				return
		elif target_unit.Type == Data.Type.BUILDING:
			target_unit = target_unit as BuildingCardBase
			if target_unit.capacity > 0 and selected_unit_type != Data.Type.BUILDING:
				occupy_cell_map[position]=target_unit
				return
			if target_unit.capacity==0:
				var child:CardBaseOnmap = target_unit.get_node("Garrison").get_child(0)
				if child.Type == Data.Type.CHARACTER and selected_unit_type ==\
				 Data.Type.VEHICLE:
					occupy_cell_map[position]=target_unit
					return
				child = child as VehicleCardBase
				if child.Type==Data.Type.VEHICLE and child.capacity > 0 and\
				 selected_unit_type==Data.Type.CHARACTER:
					occupy_cell_map[position]=target_unit
					return
		
				
				
