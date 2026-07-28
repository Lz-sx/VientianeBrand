extends StateBase

func _on_enter() -> void:
	Events.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	Events.building_attack.connect(_on_building_attack)
	Events.building_skill.connect(_on_building_skill)
	Events.vehicle_attack.connect(_on_vehicle_attack)
	Events.vehicle_move.connect(_on_vehicle_move)
	Events.vehicle_skill.connect(_on_vehicle_skill)
	Events.character_attack.connect(_on_character_attack)
	Events.character_move.connect(_on_character_move)
	Events.character_skill.connect(_on_character_skill)
	Events.weapon_skill.connect(_on_weapon_skill)
	Events.armor_skill.connect(_on_armor_skill)

	main_game.map_card_info.update_text(main_game.map_card_be_selected)
	main_game.map_card_info.visible = true
	if main_game.map_card_be_selected.Faction == Data.Faction.PLAYER1:
		main_game.map_card_operate.update_button(main_game.map_card_be_selected)
		main_game.map_card_operate.visible = true

	
## 退出状态时触发
func _on_exit() -> void:
	Events.hand_card_selected_changed.disconnect(_on_hand_card_selected_changed)
	Events.hand_card_selected_changed.disconnect(_on_hand_card_selected_changed)
	Events.building_attack.disconnect(_on_building_attack)
	Events.building_skill.disconnect(_on_building_skill)
	Events.vehicle_attack.disconnect(_on_vehicle_attack)
	Events.vehicle_move.disconnect(_on_vehicle_move)
	Events.vehicle_skill.disconnect(_on_vehicle_skill)
	Events.character_attack.disconnect(_on_character_attack)
	Events.character_move.disconnect(_on_character_move)
	Events.character_skill.disconnect(_on_character_skill)
	Events.weapon_skill.disconnect(_on_weapon_skill)
	Events.armor_skill.disconnect(_on_armor_skill)
	main_game.map_card_info.visible = false
	main_game.map_card_operate.visible = false

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		var target_pos = main_game.map.get_hovered_tile()
		if main_game.game_grid.grid_data[target_pos]["unit"] != null:
			main_game.map_card_be_selected = main_game.game_grid.grid_data[target_pos]["unit"]
			parent_fsm.change_state("IdleState")
	if _event.is_action_pressed("mouse_right"):
		main_game.map_card_be_selected = null
		parent_fsm.change_state("IdleState")

func _on_hand_card_selected_changed():
	main_game.map_card_be_selected = null
	parent_fsm.change_state("IdleState")

func find_vehicle(card_be_selected:CardBaseOnmap) -> VehicleCardBase:
	if card_be_selected is BuildingCardBase:
		card_be_selected = card_be_selected as BuildingCardBase
		for card in card_be_selected.get_node("Garrison").get_children():
			if card is VehicleCardBase:
				return card
	elif card_be_selected is VehicleCardBase:
		return card_be_selected
	return null

func find_character(card_be_selected:CardBaseOnmap) -> CharacterCardBase:
	if card_be_selected is BuildingCardBase:
		card_be_selected = card_be_selected as BuildingCardBase
		for card in card_be_selected.get_node("Garrison").get_children():
			if card is VehicleCardBase:
				for card2 in card.get_node("Passenger").get_children():
					if card2 is CharacterCardBase:
						return card2
			if card is CharacterCardBase:
				return card
	elif card_be_selected is VehicleCardBase:
		for card2 in card_be_selected.get_node("Passenger").get_children():
			if card2 is CharacterCardBase:
				return card2
	elif card_be_selected is CharacterCardBase:
		return card_be_selected
	return null

func _can_action(faction:Data.Faction) -> bool:
	if faction == Data.Faction.PLAYER1:
		if main_game.current_player1_action_point > 0:
			return true
		else:
			print("体力用尽")
			return false
	elif faction == Data.Faction.PLAYER2:
		if main_game.current_player2_action_point > 0:
			return true
		else:
			print("体力用尽")
			return false
	return false
	
func _on_building_attack():
	if not _can_action(Data.Faction.PLAYER1):
		return
	main_game.map_action_card = main_game.map_card_be_selected
	parent_fsm.change_state("PreAttackState")

func _on_building_skill():
	pass
	
func _on_vehicle_attack():
	if not _can_action(Data.Faction.PLAYER1):
		return
	main_game.map_action_card = find_vehicle(main_game.map_card_be_selected)
	parent_fsm.change_state("PreAttackState")
	
func _on_vehicle_move():
	if not _can_action(Data.Faction.PLAYER1):
		return
	main_game.map_action_card = find_vehicle(main_game.map_card_be_selected)
	parent_fsm.change_state("PreMoveState")
	
func _on_vehicle_skill():
	pass

func _on_character_attack():
	if not _can_action(Data.Faction.PLAYER1):
		return
	main_game.map_action_card = find_character(main_game.map_card_be_selected)
	parent_fsm.change_state("PreAttackState")
	
func _on_character_move():
	if not _can_action(Data.Faction.PLAYER1):
		return
	main_game.map_action_card = find_character(main_game.map_card_be_selected)
	print(main_game.map_action_card)
	parent_fsm.change_state("PreMoveState")
	
func _on_character_skill():
	pass
	
func _on_weapon_skill():
	pass

func _on_armor_skill():
	pass
