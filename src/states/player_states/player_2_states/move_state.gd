extends StateBase

func _on_enter() -> void:
	
	main_game.current_player2_action_point -= 1
	NetRelay.rpc("net_sync_action_point", main_game.current_player2_action_point)
	
	if main_game.player2_map_card_be_selected_id != main_game.player2_map_action_card_id:
		main_game.occupancy.vacate_by_id(main_game.player2_map_action_card_id)
	NetRelay.rpc("net_sync_is_in_player2_move_range", main_game.player2_clicked_position)
	NetRelay.rpc("net_sync_is_in_player2_occupy_cell_map", main_game.player2_clicked_position)
	if main_game.grid_range.is_in_player2_move_range:
		main_game.movement.move_by_id(main_game.player2_map_action_card_id,\
		main_game.player2_clicked_position)
		main_game.player2_map_card_be_selected_id = main_game.player2_map_action_card_id
		NetRelay.rpc("net_reply_player2_update_text",main_game.player2_map_card_be_selected_id)
		NetRelay.rpc("net_reply_player2_update_button",main_game.player2_map_card_be_selected_id)
	elif main_game.grid_range.is_in_player2_occupy_cell_map:
		main_game.movement.move_by_id(main_game.player2_map_action_card_id,\
		main_game.player2_clicked_position)
		await get_tree().create_timer(0.5).timeout
		main_game.occupancy.occupy(main_game.player2_map_action_card_id,\
		main_game.player2_clicked_position)
		
		#改到这里了############################################################
		main_game.map_card_be_selected = null
		main_game.map_card_info.visible = false
		main_game.map_card_operate.visible = false
		
	parent_fsm.change_state("IdleState")
## 退出状态时触发
func _on_exit() -> void:
	main_game.map_action_card = null
	main_game.grid_range.clear()
	
## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
