extends Node
class_name Occupancy
@export var game_grid: GameGrid
@export var unit_spawner: UnitSpawner
@export var movement: Movement
@export var map: Map

#@export var y_offset:Vector2i = Vector2i(0,-5)
const  OCCUPY_OFFSET_RIGHT:Vector2i = Vector2i(5,-13)
const  OCCUPY_OFFSET_LEFT:Vector2i = Vector2i(-5,-13)
const  ROTATION_RIGHT:int = 30
const  ROTATION_LEFT:int = -30


func remove_node(selected_unit:CardBaseOnmap):
	if selected_unit.get_parent() != null:
		selected_unit.get_parent().remove_child(selected_unit)
	game_grid.remove_unit_by_unit(selected_unit)

func occupy_unit(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap) -> int:
	if selected_unit.Faction == target_unit.Faction:
		if target_unit.Type == Data.Type.VEHICLE:
			target_unit = target_unit as VehicleCardBase
			if target_unit.capacity > 0 and selected_unit.Type == Data.Type.CHARACTER:
				remove_node(selected_unit)
				target_unit.get_node("Passenger").add_child(selected_unit)
				target_unit.capacity-=1
				return 0
			if selected_unit.Type == Data.Type.BUILDING:
				selected_unit = selected_unit as BuildingCardBase
				var pos_raw = game_grid.grid_data.find_key(target_unit)
				if pos_raw == null:
					return -1
				# 复制一份独立坐标，不受字典删除影响
				var pos:Vector2i = pos_raw.duplicate()
				remove_node(target_unit)
				game_grid.add_unit(selected_unit,pos)
				selected_unit.position = map.get_global_from_tile(pos)
				selected_unit.capacity -= 1
				selected_unit.get_node("Garrison").add_child(target_unit)
				return 5
		elif target_unit.Type == Data.Type.BUILDING:
			target_unit = target_unit as BuildingCardBase
			if target_unit.capacity > 0 and selected_unit.Type == Data.Type.VEHICLE:
				remove_node(selected_unit)
				target_unit.get_node("Garrison").add_child(selected_unit)
				target_unit.capacity-=1
				return 1
			if target_unit.capacity > 0 and selected_unit.Type == Data.Type.CHARACTER:
				remove_node(selected_unit)
				target_unit.get_node("Garrison").add_child(selected_unit)
				target_unit.capacity-=1
				return 2
			if target_unit.capacity==0:
				var child:CardBaseOnmap = target_unit.get_node("Garrison").get_child(0)
				if child.Type == Data.Type.CHARACTER and selected_unit.Type == Data.Type.VEHICLE:
					selected_unit = selected_unit as VehicleCardBase
					remove_node(selected_unit)
					remove_node(child)
					selected_unit.get_node("Passenger").add_child(child)
					selected_unit.capacity-=1
					target_unit.get_node("Garrison").add_child(selected_unit)
					return 3
				child = child as VehicleCardBase
				if child.Type==Data.Type.VEHICLE and child.capacity > 0 and selected_unit.Type==Data.Type.CHARACTER:
					remove_node(selected_unit)
					child.get_node("Passenger").add_child(child)
					child.capacity-=1
					return 4
		elif target_unit.Type == Data.Type.CHARACTER:
			if selected_unit.Type == Data.Type.BUILDING:
				selected_unit = selected_unit as BuildingCardBase
				var pos = game_grid.grid_data.find_key(target_unit)
				remove_node(target_unit)
				game_grid.add_unit(selected_unit,pos)
				selected_unit.capacity -= 1
				selected_unit.get_node("Garrison").add_child(target_unit)
				return 6
			elif selected_unit.Type == Data.Type.VEHICLE:
				selected_unit = selected_unit as VehicleCardBase
				var pos = game_grid.grid_data.find_key(target_unit)
				remove_node(target_unit)
				game_grid.add_unit(selected_unit,pos)
				selected_unit.capacity -= 1
				selected_unit.get_node("Passenger").add_child(target_unit)
				return 7
	return -1
			
func vacate_unit(selected_unit:CardBaseOnmap,tile_position:Vector2i):
	if selected_unit.Type!=Data.Type.BUILDING:
		if selected_unit.get_parent() != null:
			selected_unit.get_parent().get_parent().capacity+=1
			selected_unit.get_parent().remove_child(selected_unit)
		unit_spawner.container.add_child(selected_unit)

func rotate(unit:CardBaseOnmap,position:Vector2i,rotation:int):
	unit.get_node("Sprite2D").scale += Vector2(0.4,0.4)
	var tween:Tween = create_tween()
	# 同时平滑移动位置 + 旋转
	tween.tween_property(unit, "position", position, 0.4)
	tween.tween_property(unit, "rotation_degrees", rotation, 0.4)
	# 缓动曲线，流畅自然
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

func occupy(selected_unit:CardBaseOnmap,tile_position:Vector2i):
	var target_unit = game_grid.get_cell_data(tile_position)["unit"]
	print(selected_unit.id)
	print(target_unit.id)
	print("占据")
	movement.move(selected_unit,tile_position)
	selected_unit.shield_and_hp_off()
	match occupy_unit(selected_unit,target_unit):
		0:
			await rotate(selected_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
			await rotate(target_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
		1:
			selected_unit = selected_unit as VehicleCardBase
			if selected_unit.capacity == Data.card_data[selected_unit.id]["capacity"]:
				await rotate(selected_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
		2:
			await rotate(selected_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
		3:
			await rotate(selected_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
		4:
			await rotate(selected_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
		5:
			await rotate(target_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
		6:
			await rotate(target_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
		7:
			await rotate(target_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
			await rotate(selected_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
		_:
			push_warning("错误：occupy函数判断链")
	
func vacate(selected_unit:CardBaseOnmap,tile_position:Vector2i):
	if selected_unit.Type == Data.Type.CHARACTER:
		rotate(selected_unit,OCCUPY_OFFSET_LEFT,ROTATION_LEFT)
	elif selected_unit.Type == Data.Type.VEHICLE:
		selected_unit = selected_unit as VehicleCardBase
		if selected_unit.capacity == Data.card_data[selected_unit.id]["capacity"]:
			rotate(selected_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
	selected_unit.shield_and_hp_on()
	movement.move(selected_unit,tile_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
