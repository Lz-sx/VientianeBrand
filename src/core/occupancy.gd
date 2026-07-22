extends Node
class_name Occupancy
@export var game_grid: GameGrid
@export var unit_spawner: UnitSpawner
@export var movement: Movement
@export var map: Map
@export var grid_range: GridRange



enum OccupyResult {
	CHARACTER_TO_VEHICLE = 0,
	VEHICLE_TO_BUILDING = 1,
	CHARACTER_TO_BUILDING = 2,
	VEHICLE_REPLACE_BUILDING_CHAR = 3,
	CHARACTER_TO_BUILDING_VEHICLE = 4,
	BUILDING_REPLACE_VEHICLE = 5,
	BUILDING_REPLACE_CHARACTER = 6,
	VEHICLE_REPLACE_CHARACTER = 7,
	FAILED = -1
}

func remove_node(selected_unit:CardBaseOnmap):
	if selected_unit.get_parent() != null:
		selected_unit.get_parent().remove_child(selected_unit)
	var pos = grid_range.active_unit_map.find_key(selected_unit)
	if not pos == null:
		game_grid.remove_unit_by_pos(pos)

func _occupy_character_to_vehicle(selected:CardBaseOnmap, vehicle:VehicleCardBase) -> OccupyResult:
	if vehicle.capacity > 0:
		remove_node(selected)
		vehicle.get_node("Passenger").add_child(selected)
		vehicle.capacity -= 1
		return OccupyResult.CHARACTER_TO_VEHICLE
	return OccupyResult.FAILED

func _occupy_building_replace_vehicle(selected:BuildingCardBase, vehicle:VehicleCardBase) -> OccupyResult:
	var pos = grid_range.occupy_cell_map.find_key(vehicle)
	if pos == null:
		return OccupyResult.FAILED
	remove_node(vehicle)
	
	if selected.get_parent() != null:
		selected.get_parent().remove_child(selected)
	
	game_grid.add_unit(selected, pos)
	selected.position = map.get_global_from_tile(pos)
	unit_spawner.container.add_child(selected)
	
	selected.capacity -= 1
	var garrison = selected.get_node_or_null("Garrison")
	if garrison == null:
		return OccupyResult.FAILED
	garrison.add_child(vehicle)
	return OccupyResult.BUILDING_REPLACE_VEHICLE

func _occupy_vehicle_to_building(selected:VehicleCardBase, building:BuildingCardBase) -> OccupyResult:
	if building.capacity > 0:
		remove_node(selected)
		building.get_node("Garrison").add_child(selected)
		building.capacity -= 1
		return OccupyResult.VEHICLE_TO_BUILDING
	return OccupyResult.FAILED

func _occupy_character_to_building(selected:CardBaseOnmap, building:BuildingCardBase) -> OccupyResult:
	if building.capacity > 0:
		remove_node(selected)
		building.get_node("Garrison").add_child(selected)
		building.capacity -= 1
		return OccupyResult.CHARACTER_TO_BUILDING
	return OccupyResult.FAILED

func _occupy_vehicle_replace_building_char(selected:VehicleCardBase, building:BuildingCardBase) -> OccupyResult:
	var garrison = building.get_node_or_null("Garrison")
	var passenger = selected.get_node_or_null("Passenger")
	if garrison == null or passenger == null:
		return OccupyResult.FAILED
	
	if garrison.get_child_count() == 0:
		return OccupyResult.FAILED
	
	var child:CardBaseOnmap = garrison.get_child(0)
	if child.Type == Data.Type.CHARACTER:
		remove_node(selected)
		remove_node(child)
		passenger.add_child(child)
		selected.capacity -= 1
		garrison.add_child(selected)
		return OccupyResult.VEHICLE_REPLACE_BUILDING_CHAR
	return OccupyResult.FAILED

func _occupy_character_to_building_vehicle(selected:CardBaseOnmap, building:BuildingCardBase) -> OccupyResult:
	var garrison = building.get_node_or_null("Garrison")
	if garrison == null or garrison.get_child_count() == 0:
		return OccupyResult.FAILED
	
	var child:CardBaseOnmap = garrison.get_child(0)
	if child.Type == Data.Type.VEHICLE:
		var vehicle_child = child as VehicleCardBase
		var passenger = vehicle_child.get_node_or_null("Passenger")
		if passenger == null:
			return OccupyResult.FAILED
		if vehicle_child.capacity > 0:
			remove_node(selected)
			passenger.add_child(selected)
			vehicle_child.capacity -= 1
			return OccupyResult.CHARACTER_TO_BUILDING_VEHICLE
	return OccupyResult.FAILED

func _occupy_building_replace_character(selected:BuildingCardBase, character:CardBaseOnmap) -> OccupyResult:
	var pos = grid_range.occupy_cell_map.find_key(character)
	if pos == null:
		return OccupyResult.FAILED
	
	remove_node(character)
	
	if selected.get_parent() != null:
		selected.get_parent().remove_child(selected)
	
	game_grid.add_unit(selected, pos)
	selected.position = map.get_global_from_tile(pos)
	unit_spawner.container.add_child(selected)
	
	selected.capacity -= 1
	var garrison = selected.get_node_or_null("Garrison")
	if garrison == null:
		return OccupyResult.FAILED
	garrison.add_child(character)
	return OccupyResult.BUILDING_REPLACE_CHARACTER

func _occupy_vehicle_replace_character(selected:VehicleCardBase, character:CardBaseOnmap) -> OccupyResult:
	var pos = grid_range.occupy_cell_map.find_key(character)
	if pos == null:
		return OccupyResult.FAILED
	
	remove_node(character)
	
	if selected.get_parent() != null:
		selected.get_parent().remove_child(selected)
	
	game_grid.add_unit(selected, pos)
	selected.position = map.get_global_from_tile(pos)
	unit_spawner.container.add_child(selected)
	
	selected.capacity -= 1
	var passenger = selected.get_node_or_null("Passenger")
	if passenger == null:
		return OccupyResult.FAILED
	passenger.add_child(character)
	return OccupyResult.VEHICLE_REPLACE_CHARACTER

func occupy_unit(selected_unit:CardBaseOnmap, target_unit:CardBaseOnmap) -> OccupyResult:
	if selected_unit.Faction != target_unit.Faction:
		return OccupyResult.FAILED
	
	match target_unit.Type:
		Data.Type.VEHICLE:
			var vehicle = target_unit as VehicleCardBase
			if selected_unit.Type == Data.Type.CHARACTER:
				return _occupy_character_to_vehicle(selected_unit, vehicle)
			elif selected_unit.Type == Data.Type.BUILDING:
				return _occupy_building_replace_vehicle(selected_unit as BuildingCardBase, vehicle)
		
		Data.Type.BUILDING:
			var building = target_unit as BuildingCardBase
			if selected_unit.Type == Data.Type.VEHICLE:
				if building.capacity > 0:
					return _occupy_vehicle_to_building(selected_unit as VehicleCardBase, building)
				else:
					return _try_occupy_full_building(selected_unit, building)
			elif selected_unit.Type == Data.Type.CHARACTER:
				if building.capacity > 0:
					return _occupy_character_to_building(selected_unit, building)
				else:
					return _try_occupy_full_building(selected_unit, building)
		
		Data.Type.CHARACTER:
			if selected_unit.Type == Data.Type.BUILDING:
				return _occupy_building_replace_character(selected_unit as BuildingCardBase, target_unit)
			elif selected_unit.Type == Data.Type.VEHICLE:
				return _occupy_vehicle_replace_character(selected_unit as VehicleCardBase, target_unit)
	
	return OccupyResult.FAILED

func _try_occupy_full_building(selected:CardBaseOnmap, building:BuildingCardBase) -> OccupyResult:
	var garrison = building.get_node_or_null("Garrison")
	if garrison == null or garrison.get_child_count() == 0:
		return OccupyResult.FAILED
	
	var child = garrison.get_child(0)
	if selected.Type == Data.Type.VEHICLE and child.Type == Data.Type.CHARACTER:
		return _occupy_vehicle_replace_building_char(selected as VehicleCardBase, building)
	elif selected.Type == Data.Type.CHARACTER and child.Type == Data.Type.VEHICLE:
		return _occupy_character_to_building_vehicle(selected, building)
	
	return OccupyResult.FAILED

func vacate_unit(selected_unit:CardBaseOnmap, tile_position:Vector2i):
	if selected_unit.Type != Data.Type.BUILDING:
		if selected_unit.get_parent() != null:
			selected_unit.get_parent().get_parent().capacity += 1
			selected_unit.get_parent().remove_child(selected_unit)
		unit_spawner.container.add_child(selected_unit)
		game_grid.add_unit(selected_unit, tile_position)



func occupy(selected_unit:CardBaseOnmap, tile_position:Vector2i):
	var target_unit = game_grid.get_cell_data(tile_position)["unit"]
	if target_unit == null:
		return
	match occupy_unit(selected_unit, target_unit):
		OccupyResult.CHARACTER_TO_VEHICLE:
			target_unit = target_unit as VehicleCardBase
			target_unit.char_icon.visible = true
			selected_unit.visible = false
		OccupyResult.VEHICLE_TO_BUILDING:
			target_unit = target_unit as BuildingCardBase
			target_unit.veh_icon.visible = true
			selected_unit.visible = false
		OccupyResult.CHARACTER_TO_BUILDING:
			target_unit = target_unit as BuildingCardBase
			target_unit.char_icon.visible = true
			selected_unit.visible = false
		OccupyResult.VEHICLE_REPLACE_BUILDING_CHAR:
			target_unit = target_unit as BuildingCardBase
			target_unit.veh_icon.visible = true
			selected_unit.visible = false
		OccupyResult.CHARACTER_TO_BUILDING_VEHICLE:
			target_unit = target_unit as BuildingCardBase
			target_unit.char_icon.visible = true
			selected_unit.visible = false
		OccupyResult.BUILDING_REPLACE_VEHICLE:
			print(1)
			target_unit = target_unit as VehicleCardBase
			selected_unit = selected_unit as BuildingCardBase
			print(target_unit.capacity)
			print(Data.card_data[target_unit.id]["capacity"])
			if target_unit.capacity != Data.card_data[target_unit.id]["capacity"]:
				selected_unit.char_icon.visible = true
			target_unit.visible = false
			selected_unit.veh_icon.visible = true
		OccupyResult.BUILDING_REPLACE_CHARACTER:
			selected_unit = selected_unit as BuildingCardBase
			target_unit.visible = false
			selected_unit.char_icon.visible = true
		OccupyResult.VEHICLE_REPLACE_CHARACTER:
			selected_unit = selected_unit as VehicleCardBase
			target_unit.visible = false
			selected_unit.char_icon.visible = true
		OccupyResult.FAILED:
			push_warning("错误：occupy函数判断链")

func vacate(selected_unit:CardBaseOnmap, tile_position:Vector2i):
	if selected_unit.Type == Data.Type.CHARACTER:
		pass
	elif selected_unit.Type == Data.Type.VEHICLE:
		var vehicle = selected_unit as VehicleCardBase
		if vehicle.capacity == Data.card_data[selected_unit.id]["capacity"]:
			pass
	vacate_unit(selected_unit, tile_position)
	movement.move(selected_unit, tile_position)

func _ready() -> void:
	pass
