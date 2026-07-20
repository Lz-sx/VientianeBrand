extends StateBase

func _on_enter() -> void:
	main_game.unit_spawner.spawn_unit(0,main_game.map.get_hovered_tile(),Data.Faction.PLAYER1)
	parent_fsm.change_state("EndTurnState")
	
## 退出状态时触发
func _on_exit() -> void:
	main_game.draw_high_light_area.clear_highlight()
	main_game.grid_range.clear()
	main_game.hand_root.remove_card(main_game.hand_card_be_selected)
	main_game.hand_root.cancel_hand_card_selected()

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
