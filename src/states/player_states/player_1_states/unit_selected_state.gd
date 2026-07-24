extends StateBase

func _on_enter() -> void:
	main_game.map_card_info.update_text(main_game.map_card_be_selected)
	main_game.map_card_info.visible = true
	main_game.map_card_operate.update_button(main_game.map_card_be_selected)
	main_game.map_card_operate.visible = true
	
## 退出状态时触发
func _on_exit() -> void:
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
