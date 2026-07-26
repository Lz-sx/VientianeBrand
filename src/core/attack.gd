extends Node
class_name Attack

@export var main_game: MainGame

func die(unit:CardBaseOnmap):
	var parent_node = unit.get_parent()
	if parent_node == main_game.unit_spawner.container:
		if unit.Type == Data.Type.CHARACTER:
			main_game.occupancy.remove_node(unit)
		elif unit.Type == Data.Type.VEHICLE:
			var position:Vector2i = main_game.clicked_position
			main_game.occupancy.remove_node(unit)
			for child in unit.get_node("Passenger").get_children():
				main_game.occupancy.remove_node(child)
				parent_node.add_child(child)
				main_game.game_grid.add_unit(child,position)
		elif unit.Type == Data.Type.BUILDING:
			var position:Vector2i = main_game.clicked_position
			main_game.occupancy.remove_node(unit)
			for child in unit.get_node("Garrison").get_children():
				main_game.occupancy.remove_node(child)
				parent_node.add_child(child)
				main_game.game_grid.add_unit(child,position)
	else:
		if unit.Type == Data.Type.CHARACTER:
			parent_node.get_parent().capacity += 1
			main_game.occupancy.remove_node(unit)
		elif unit.Type == Data.Type.VEHICLE:
			var position:Vector2i = main_game.clicked_position
			main_game.occupancy.remove_node(unit)
			for child in unit.get_node("Passenger").get_children():
				main_game.occupancy.remove_node(child)
				parent_node.add_child(child)
				main_game.game_grid.add_unit(child,position)
	Events.unit_died.emit(unit)
	print(main_game.game_grid.grid_data[Vector2i(0,0)])
	unit.queue_free()
		
func attack_unit(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap):
	print(main_game.game_grid.grid_data[Vector2i(0,0)])

	var damage_reduction:int = 0
	if target_unit.Type == Data.Type.CHARACTER:
		for armor in target_unit.get_node("Armor").get_children():
			armor = armor  as ArmorCardBase
			damage_reduction += armor.damage_reduction
	var damage:int = selected_unit.damage - damage_reduction
	if target_unit.shield > 0:
		target_unit.shield-=damage
		target_unit.update_shield()
	else:
		target_unit.hp -= damage
		target_unit.update_hp()
		if target_unit.hp == 0:
			die(target_unit)

func attack(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap):
	# 攻击单位抬手动画：轻微向前弹出再复位
	var attack_tween:Tween = selected_unit.create_tween()
	attack_tween.set_trans(Tween.TRANS_SINE)
	attack_tween.set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(selected_unit, "scale", Vector2(1, 1), 0.1)
	attack_tween.tween_property(selected_unit, "scale", Vector2(0.7, 0.7), 0.15)
	attack_tween.finished.connect(func():
		hit_animation(target_unit)
		attack_unit(selected_unit, target_unit)
		Events.attack_finished.emit(selected_unit, target_unit)
	)
	
# 目标受击动画：红闪+左右抖动
func hit_animation(target: CardBaseOnmap):
	var origin_color = target.modulate
	var origin_pos = target.position
	var hit_tween = target.create_tween()
	hit_tween.set_trans(Tween.TRANS_SINE)
	# 变红
	hit_tween.tween_property(target, "modulate", Color(1, 0.3, 0.3), 0.05)
	# 左右抖动3次
	for i in 3:
		hit_tween.tween_property(target, "position", origin_pos + Vector2(4, 0), 0.04)
		hit_tween.tween_property(target, "position", origin_pos - Vector2(4, 0), 0.04)
	# 归位、恢复原色
	hit_tween.tween_property(target, "position", origin_pos, 0.04)
	hit_tween.tween_property(target, "modulate", origin_color, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
