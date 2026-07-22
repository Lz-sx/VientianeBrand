extends StateBase

func _on_enter() -> void:
	Events.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	main_game.grid_range.find_deploy_range(Data.Faction.PLAYER1,main_game.hand_card_be_selected.Type)
	main_game.grid_range.find_arm_slot_map(Data.Faction.PLAYER1,main_game.hand_card_be_selected.Type)
	main_game.draw_high_light_area.draw_deploy_highlight()
	main_game.hand_card_info.show_hand_panel(main_game.hand_card_be_selected.id)
## 退出状态时触发
func _on_exit() -> void:
	Events.hand_card_selected_changed.disconnect(_on_hand_card_selected_changed)
	main_game.hand_card_info.hide_hand_panel()
## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		var target_pos = main_game.map.get_hovered_tile()
		if main_game.grid_range.deploy_range.has(target_pos) or \
		main_game.grid_range.occupy_cell_map.has(target_pos) or \
		main_game.grid_range.arm_slot_map.has(target_pos):
			parent_fsm.change_state("DeployState")
		
func _on_hand_card_selected_changed():
	parent_fsm.change_state("IdleState")
