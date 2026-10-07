extends StateBase

func _on_enter() -> void:
	main_game.grid_range.is_in_player2_arm_slot_map_synced = false
	main_game.grid_range.is_in_player2_deploy_range_synced = false
	main_game.grid_range.is_in_player2_occupy_cell_map_synced = false
	
	NetRelay.rpc("net_request_is_in_player2_deploy_range", main_game.player2_clicked_position)
	NetRelay.rpc("net_request_is_in_player2_occupy_cell_map", main_game.player2_clicked_position)
	NetRelay.rpc("net_request_is_in_player2_arm_slot_map", main_game.player2_clicked_position)
	
	while not (main_game.grid_range.is_in_player2_deploy_range_synced \
			and main_game.grid_range.is_in_player2_occupy_cell_map_synced \
			and main_game.grid_range.is_in_player2_arm_slot_map_synced):
		await get_tree().process_frame
	
	main_game.grid_range.is_in_player2_arm_slot_map_synced = false
	main_game.grid_range.is_in_player2_deploy_range_synced = false
	main_game.grid_range.is_in_player2_occupy_cell_map_synced = false
	
	if main_game.grid_range.is_in_player2_deploy_range:
		main_game.unit_spawner.spawn_unit(main_game.player2_hand_card_be_selected_id,\
		main_game.player2_clicked_position,Data.Faction.PLAYER2)
	elif main_game.grid_range.is_in_player2_occupy_cell_map:
		var id = main_game.player2_hand_card_be_selected_id
		main_game.unit_spawner.spawn_unit(id,main_game.player2_clicked_position,Data.Faction.PLAYER2)
		main_game.occupancy.occupy(id,main_game.player2_clicked_position)
	elif main_game.grid_range.is_in_player2_arm_slot_map:
		main_game.arm.spawn_and_equip_weapon(main_game.player2_hand_card_be_selected_id,\
		Data.card_data[main_game.player2_hand_card_be_selected_id]["type"],main_game.player2_clicked_position)
	
	
	
	parent_fsm.change_state("IdleState")
	
## 退出状态时触发
func _on_exit() -> void:
	NetRelay.rpc("net_reply_player2_deploystate_exit")
	

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass
	
## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
