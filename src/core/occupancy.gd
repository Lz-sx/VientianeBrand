extends Node
class_name Occupancy
@export var game_grid: GameGrid
@export var unit_spawner: UnitSpawner
@export var movement: Movement

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
				return 0
		elif target_unit.Type == Data.Type.BUILDING:
				target_unit = target_unit as BuildingCardBase
				if target_unit.capacity > 0 and selected_unit.Type != Data.Type.BUILDING:
					remove_node(selected_unit)
					target_unit.get_node("Garrison").add_child(selected_unit)
					return 1
				if target_unit.capacity==0:
					var child:CardBaseOnmap = target_unit.get_node("Garrison").get_child(0)
					if child.Type == Data.Type.CHARACTER and selected_unit.Type == Data.Type.VEHICLE:
						remove_node(selected_unit)
						remove_node(child)
						selected_unit.get_node("Passenger").add_child(child)
						target_unit.get_node("Garrison").add_child(selected_unit)
						return 2
					child = child as VehicleCardBase
					if child.Type==Data.Type.VEHICLE and child.capacity > 0 and selected_unit.Type==Data.Type.CHARACTER:
						remove_node(selected_unit)
						child.get_node("Passenger").add_child(child)
						return 3
	return -1
			
func vacate_unit(selected_unit:CardBaseOnmap,tile_position:Vector2i):
	if selected_unit.Type!=Data.Type.BUILDING:
		if selected_unit.get_parent() != null:
			selected_unit.get_parent().remove_child(selected_unit)
		unit_spawner.container.add_child(selected_unit)

func occupy_move(unit:CardBaseOnmap,position:Vector2i,rotation:int):
	var tween:Tween = create_tween()
	# 同时平滑移动位置 + 旋转
	tween.tween_property(unit, "position", position, 0.4)
	tween.tween_property(unit, "rotation_degrees", rotation, 0.4)
	# 缓动曲线，流畅自然
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)


func occupy(selected_unit:CardBaseOnmap,tile_position:Vector2i):
	var target_unit = game_grid.get_cell_data(tile_position)
	movement.move(selected_unit,tile_position)
	match occupy_unit(selected_unit,target_unit):
		0:
			occupy_move(selected_unit,OCCUPY_OFFSET_RIGHT,ROTATION_RIGHT)
		1:
			pass
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
