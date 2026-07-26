extends StateBase

func _on_enter() -> void:
	main_game.grid_range.find_active_unit_map()
	main_game.grid_range.find_attack_range(main_game.grid_range.active_unit_map.find_key\
	(main_game.map_card_be_selected),main_game.map_action_card)
	main_game.draw_high_light_area.draw_attack_highlight()
	
## 退出状态时触发
func _on_exit() -> void:
	main_game.draw_high_light_area.clear_highlight()

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		main_game.clicked_position = main_game.map.get_hovered_tile()
		if main_game.grid_range.attack_range.has(main_game.clicked_position):
			parent_fsm.change_state("AttackState")
	if _event.is_action_pressed("mouse_right"):
		parent_fsm.change_state("UnitSelectedState")
