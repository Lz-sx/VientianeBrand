extends Node
class_name ARM
@export var grid_range: GridRange

func spawn_and_equip_weapon(id:int, arm_type:Data.Type, pos:Vector2i) -> Node2D:
	if not Data.card_data.has(id):
		print("错误：不存在卡牌ID ", id)
		return null
	var unit_scene: PackedScene = Data.card_data[id]["map_uid"]
	if unit_scene == null:
		print("错误：卡牌场景资源为空 ID ", id)
		return null
	
	var unit_instance = unit_scene.instantiate()
	
	var target_card = _find_character_at_position(pos)
	if target_card == null:
		unit_instance.queue_free()
		return null
	
	if arm_type == Data.Type.WEAPON:
		var weapon_node = target_card.get_node_or_null("Weapon")
		if weapon_node != null and weapon_node.get_child_count() == 0:
			weapon_node.add_child(unit_instance)
			target_card.wea_icon.visible = true
			weapon_node = weapon_node as WeaponCardBase
			target_card.damage += unit_instance.damage_bonus
			target_card.attack_range += unit_instance.attack_range_bonus
			return unit_instance
	elif arm_type == Data.Type.ARMOR:
		var armor_node = target_card.get_node_or_null("Armor")
		if armor_node != null and armor_node.get_child_count() == 0:
			armor_node.add_child(unit_instance)
			target_card.arm_icon.visible = true
			return unit_instance
	
	unit_instance.queue_free()
	return null

func _find_character_at_position(pos:Vector2i) -> CharacterCardBase:
	if not grid_range.active_unit_map.has(pos):
		return null
	
	return _find_character_in_unit(grid_range.active_unit_map[pos])

func _find_character_in_unit(unit:CardBaseOnmap) -> CharacterCardBase:
	if unit.Type == Data.Type.CHARACTER:
		return unit as CharacterCardBase
	
	elif unit.Type == Data.Type.VEHICLE:
		var vehicle = unit as VehicleCardBase
		var passenger = vehicle.get_node_or_null("Passenger")
		if passenger != null:
			for child in passenger.get_children():
				var result = _find_character_in_unit(child)
				if result != null:
					return result
	
	elif unit.Type == Data.Type.BUILDING:
		var building = unit as BuildingCardBase
		var garrison = building.get_node_or_null("Garrison")
		if garrison != null:
			for child in garrison.get_children():
				var result = _find_character_in_unit(child)
				if result != null:
					return result
	
	return null
