extends StateBase

func _on_enter() -> void:
	Events.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	main_game.draw_high_light_area.clear_highlight()
	main_game.grid_range.clear()
	if not main_game.hand_card_be_selected == null and not main_game.hand_card_be_selected == null:
		push_warning("错误：同时选择两张卡")
	if not main_game.hand_card_be_selected == null:
		parent_fsm.change_state("HandOperateState")
	if not main_game.map_card_be_selected == null:
		parent_fsm.change_state("UnitSelectedState")
## 退出状态时触发
func _on_exit() -> void:
	Events.hand_card_selected_changed.disconnect(_on_hand_card_selected_changed)

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		var target_pos = main_game.map.get_hovered_tile()
		if main_game.game_grid.grid_data[target_pos]["unit"] != null:
			main_game.map_card_be_selected = main_game.game_grid.grid_data[target_pos]["unit"]
			parent_fsm.change_state("UnitSelectedState")

func _on_hand_card_selected_changed():
	parent_fsm.change_state("HandOperateState")
