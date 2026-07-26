extends StateBase

func _on_enter() -> void:
	if main_game.map_card_be_selected != main_game.map_action_card:
		await main_game.occupancy.vacate(main_game.map_action_card)
	if main_game.grid_range.move_range.has(main_game.clicked_position):
		await main_game.movement.move(main_game.map_action_card,main_game.clicked_position)
		main_game.map_card_be_selected = main_game.map_action_card
		parent_fsm.change_state("UnitSelectedState")
	elif main_game.grid_range.occupy_cell_map.has(main_game.clicked_position):
		await main_game.movement.move(main_game.map_action_card,main_game.clicked_position)
		await get_tree().create_timer(0.5).timeout
		await main_game.occupancy.occupy(main_game.map_action_card,main_game.clicked_position)
		main_game.map_card_be_selected = null
		parent_fsm.change_state("IdleState")
## 退出状态时触发
func _on_exit() -> void:
	main_game.map_action_card = null
	main_game.grid_range.clear()
	main_game.grid_range.find_active_unit_map()

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
