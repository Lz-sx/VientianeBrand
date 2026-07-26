extends StateBase

func _on_enter() -> void:
	
	main_game.current_player1_action_point -= 1
	main_game.action_point.update_point(main_game.current_player1_action_point)
	
	if main_game.grid_range.active_unit_map.has(main_game.clicked_position):
		await main_game.combat.attack(main_game.map_action_card,main_game.grid_range.active_unit_map\
		[main_game.clicked_position])
		parent_fsm.change_state("UnitSelectedState")
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
