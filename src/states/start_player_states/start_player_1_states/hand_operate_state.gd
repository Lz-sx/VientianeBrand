extends StateBase

func _on_enter() -> void:
	main_game.hand_root.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	
	main_game.grid_range.find_start_range(Data.Faction.PLAYER1)
	main_game.draw_high_light_area.draw_start_highlight()
	
## 退出状态时触发
func _on_exit() -> void:
	main_game.hand_root.hand_card_selected_changed.disconnect(_on_hand_card_selected_changed)

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		var target_pos = main_game.map.get_hovered_tile()
		if main_game.grid_range.start_range.has(target_pos):
			parent_fsm.change_state("DeployState")

func _on_hand_card_selected_changed():
	parent_fsm.change_state("IdleState")
