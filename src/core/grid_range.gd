extends Node
class_name  GridRange

@export var game_grid: GameGrid

#位置
var attack_grid:Array[Vector2i]
var move_grid:Array[Vector2i]
#位置中所有的单位
var units_in_attack_grid:Array[CardBaseOnmap]
var units_in_move_grid:Array[CardBaseOnmap]
#可交互位置和其中单位
var attackable_cells_and_units:Dictionary
var occupancy_cells_and_units:Dictionary


func get_cells_in_range(center: Vector2i, range: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []	
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if abs(x) + abs(y) <= range:
				cells.append(center + Vector2i(x, y))
	return cells
	
# 四个方向：上下左右
const DIRS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]

func find_move_grid(center: Vector2i, selected_unit:CardBaseOnmap, speed: int) -> void:
	move_grid.clear()
	units_in_move_grid.clear()
	occupancy_cells_and_units.clear()
	# BFS 队列：存 [坐标, 已走步数]
	var queue: Array = [[center, 0]]
	# 记录已访问的格子，避免重复
	var visited: Dictionary = {center: true}
	while queue.size() > 0:
		var current = queue.pop_front()
		var pos: Vector2i = current[0]
		var steps: int = current[1]
		move_grid.append(pos)  # 可达格子加入结果
		# 步数到上限就不再扩展
		if steps >= speed:
			continue
		# 扩展四个方向
		for dir in DIRS:
			var next_pos: Vector2i = pos + dir
			# 已经访问过就跳过
			if visited.has(next_pos):
				continue
			# 判断障碍物：有单位就不能走
			if game_grid.grid_data[next_pos]["obstacle"] == game_grid.Obstacle.ROCK:
				continue
			if game_grid.grid_data[next_pos]["unit"] != null:
				units_in_move_grid.append(game_grid.grid_data[next_pos]["unit"])
				
				find_occupiable_cells_and_units(selected_unit,game_grid.grid_data[next_pos]["unit"],next_pos)
				continue
			visited[next_pos] = true
			queue.append([next_pos, steps + 1])

func find_attack_grid(center: Vector2i, selected_unit:CardBaseOnmap,range: int):
	attack_grid.clear()
	units_in_attack_grid.clear()
	attackable_cells_and_units.clear()
	attack_grid = get_cells_in_range(center,range)
	for position in attack_grid:
		if game_grid.grid_data[position]["unit"] != null:
			units_in_attack_grid.append(game_grid.grid_data[position]["unit"])
			find_attackable_cells_and_units(selected_unit,game_grid.grid_data[position]["unit"],position)
			

func find_attackable_cells_and_units(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap,position:Vector2i):
	if selected_unit.Faction != target_unit.Faction:
		attackable_cells_and_units[position]=target_unit
		
func find_occupiable_cells_and_units(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap,position:Vector2i):
	if selected_unit.Faction == target_unit.Faction:
		if target_unit.Type == Data.Type.VEHICLE:
			target_unit = target_unit as VehicleCardBase
			if target_unit.capacity > 0 and selected_unit.Type!=Data.Type.VEHICLE and selected_unit.Type!=Data.Type.BUILDING:
				occupancy_cells_and_units[position]=target_unit
				return
		elif target_unit.Type == Data.Type.BUILDING:
			target_unit = target_unit as BuildingCardBase
			if target_unit.capacity > 0 and selected_unit.Type != Data.Type.BUILDING:
				occupancy_cells_and_units[position]=target_unit
				return
			if target_unit.capacity==0:
				var child:CardBaseOnmap = target_unit.get_node("Garrison").get_child(0)
				if child.Type == Data.Type.CHARACTER and selected_unit.Type == Data.Type.VEHICLE:
					occupancy_cells_and_units[position]=target_unit
					return
				child = child as VehicleCardBase
				if child.Type==Data.Type.VEHICLE and child.capacity > 0 and selected_unit.Type==Data.Type.CHARACTER:
					occupancy_cells_and_units[position]=target_unit
					return
				
				
