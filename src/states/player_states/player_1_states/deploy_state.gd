extends StateBase

func _on_enter() -> void:
	if main_game.grid_range.deploy_range.has(main_game.map.get_hovered_tile()):
		main_game.unit_spawner.spawn_unit(main_game.hand_card_be_selected.id,\
		main_game.map.get_hovered_tile(),Data.Faction.PLAYER1)
	elif main_game.grid_range.occupy_cell_map.has(main_game.map.get_hovered_tile()):
		var card_on_map = main_game.unit_spawner.spawn_unit(main_game.hand_card_be_selected.id,\
		main_game.map.get_hovered_tile(),Data.Faction.PLAYER1)
		main_game.occupancy.occupy(card_on_map,main_game.map.get_hovered_tile())
	parent_fsm.change_state("IdleState")
	
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
