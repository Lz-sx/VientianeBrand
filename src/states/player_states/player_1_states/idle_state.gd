extends StateBase

func _on_enter() -> void:
	pass
	
## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if main_game.hand_card_be_selected != null:
		if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
			main_game.clicked_position = main_game.map.get_hovered_tile()
			if main_game.grid_range.deploy_range.has(main_game.clicked_position) or \
			main_game.grid_range.occupy_cell_map.has(main_game.clicked_position) or \
			main_game.grid_range.arm_slot_map.has(main_game.clicked_position):
				parent_fsm.change_state("DeployState")
