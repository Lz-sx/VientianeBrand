extends Node
class_name  GridRange

@export var game_grid: GameGrid


var start_range:Array[Vector2i]

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
var arm_slot_map:Dictionary

var CENTER_POSITION:Vector2i = Vector2i(-1,0)
var X_LENGTH = 20
var Y_LENGTH = 20
var START_Y = 1

func clear():
	start_range.clear()
	active_unit_map.clear()
	deploy_range.clear()
	attack_range.clear()
	move_range.clear()
	units_in_attack.clear()
	units_in_move.clear()
	attack_target_map.clear()
	occupy_cell_map.clear()
	arm_slot_map.clear()

func find_start_range(selected_unit_faction:Data.Faction):
	start_range.clear()
	for x in range(-X_LENGTH/2, X_LENGTH/2):
		if selected_unit_faction == Data.Faction.PLAYER1:
			for y in range(START_Y, Y_LENGTH/2):
				if game_grid.grid_data.has(Vector2i(x,y)):
					if game_grid.grid_data[Vector2i(x,y)]["obstacle"] == game_grid.Obstacle.NULL:
						start_range.append(Vector2i(x,y))
		if selected_unit_faction == Data.Faction.PLAYER2:
			for y in range(-START_Y, -Y_LENGTH/2):
				if game_grid.grid_data.has(Vector2i(x,y)):
					if game_grid.grid_data[Vector2i(x,y)]["obstacle"] == game_grid.Obstacle.NULL:
						start_range.append(Vector2i(x,y))
						
func find_active_unit_map():
	active_unit_map.clear()
	for cell_pos in game_grid.grid_data:
		var unit = game_grid.grid_data[cell_pos]["unit"]
		if unit != null:
			active_unit_map[cell_pos] = unit

func find_deploy_range(selected_unit_faction:Data.Faction, selected_unit_type:Data.Type):
	if selected_unit_type == Data.Type.WEAPON or selected_unit_type == Data.Type.ARMOR\
	or selected_unit_type == Data.Type.SKILL:
		return
	deploy_range.clear()
	find_active_unit_map()
	#交互部分查找
	for pos in active_unit_map:
		find_occupy_cell_map(selected_unit_faction,selected_unit_type,\
		active_unit_map[pos],pos)
		
	var temp_set: Dictionary = {}# key存坐标，自动去重
	for cell_pos in active_unit_map:
		var unit = active_unit_map[cell_pos]
		if unit.Faction == selected_unit_faction:
			var cells = get_cells_in_range(cell_pos, unit.deployment_range)
			for pos in cells:
				temp_set[pos] = true
	# 把唯一的key转回数组
	for pos in temp_set.keys():
		if game_grid.grid_data[pos]["obstacle"] == game_grid.Obstacle.NULL\
		 and game_grid.grid_data[pos]["unit"] == null:
			deploy_range.append(pos)
	
		
	
func get_cells_in_range(center: Vector2i, range: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []	
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if abs(x) + abs(y) <= range and abs(x) + abs(y) != 0 and \
			game_grid.grid_data.has(Vector2i(x,y)):
				if game_grid.grid_data.has(center + Vector2i(x, y)):
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
		
func find_occupy_cell_map(selected_unit_faction:Data.Faction, selected_unit_type:Data.Type,
		target_unit:CardBaseOnmap, position:Vector2i) -> bool:
	if selected_unit_faction != target_unit.Faction:
		return false
	if selected_unit_type == Data.Type.BUILDING and target_unit.Type != Data.Type.BUILDING:
		occupy_cell_map[position] = target_unit
		return true
	match target_unit.Type:
		Data.Type.VEHICLE:
			return _can_occupy_vehicle(selected_unit_type, target_unit as VehicleCardBase, position)
		Data.Type.BUILDING:
			return _can_occupy_building(selected_unit_type, target_unit as BuildingCardBase, position)
		Data.Type.CHARACTER:
			return _can_occupy_character(selected_unit_type, target_unit, position)
	
	return false

func _can_occupy_character(selected_unit_type:Data.Type, target_unit:CardBaseOnmap, position:Vector2i) -> bool:
	if selected_unit_type == Data.Type.VEHICLE or selected_unit_type == Data.Type.BUILDING:
		occupy_cell_map[position] = target_unit
		return true
	return false

func _can_occupy_vehicle(selected_unit_type:Data.Type, vehicle:VehicleCardBase, position:Vector2i) -> bool:
	if vehicle.capacity > 0 and selected_unit_type != Data.Type.VEHICLE:
		occupy_cell_map[position] = vehicle
		return true
	return false

func _can_occupy_building(selected_unit_type:Data.Type, building:BuildingCardBase, position:Vector2i) -> bool:
	if building.capacity > 0 and selected_unit_type != Data.Type.BUILDING:
		occupy_cell_map[position] = building
		return true
	
	if building.capacity == 0:
		return _can_occupy_full_building(selected_unit_type, building, position)
	
	return false

func _can_occupy_full_building(selected_unit_type:Data.Type, building:BuildingCardBase, position:Vector2i) -> bool:
	var garrison = building.get_node_or_null("Garrison")
	if garrison == null:
		return false
	
	for child in garrison.get_children():
		if child.Type == Data.Type.CHARACTER and selected_unit_type == Data.Type.VEHICLE:
			occupy_cell_map[position] = building
			return true
		elif child.Type == Data.Type.VEHICLE:
			var vehicle_child = child as VehicleCardBase
			if vehicle_child.capacity > 0 and selected_unit_type == Data.Type.CHARACTER:
				occupy_cell_map[position] = building
				return true
	
	return false
		
func find_arm_slot_map(selected_unit_faction:Data.Faction, selected_unit_type:Data.Type):
	arm_slot_map.clear()
	if selected_unit_type != Data.Type.WEAPON and selected_unit_type != Data.Type.ARMOR:
		return
	find_active_unit_map()
	for pos in active_unit_map:
		_check_unit_for_arm_slot(active_unit_map[pos], pos, selected_unit_faction, selected_unit_type)

func _check_unit_for_arm_slot(unit:CardBaseOnmap, pos:Vector2i, faction:Data.Faction, arm_type:Data.Type):
	if unit.Faction != faction:
		return
	
	if unit.Type == Data.Type.CHARACTER:
		var character = unit as CharacterCardBase
		if arm_type == Data.Type.WEAPON:
			var weapon_node = character.get_node_or_null("Weapon")
			if weapon_node != null and weapon_node.get_child_count() == 0:
				arm_slot_map[pos] = character
		elif arm_type == Data.Type.ARMOR:
			var armor_node = character.get_node_or_null("Armor")
			if armor_node != null and armor_node.get_child_count() == 0:
				arm_slot_map[pos] = character
	
	elif unit.Type == Data.Type.VEHICLE:
		var vehicle = unit as VehicleCardBase
		var passenger = vehicle.get_node_or_null("Passenger")
		if passenger != null:
			for child in passenger.get_children():
				_check_unit_for_arm_slot(child, pos, faction, arm_type)
	
	elif unit.Type == Data.Type.BUILDING:
		var building = unit as BuildingCardBase
		var garrison = building.get_node_or_null("Garrison")
		if garrison != null:
			for child in garrison.get_children():
				_check_unit_for_arm_slot(child, pos, faction, arm_type)
