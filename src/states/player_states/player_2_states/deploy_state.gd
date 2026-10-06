extends StateBase

func _on_enter() -> void:
	NetRelay.rpc("net_sync_is_in_player2_deploy_range", main_game.player2_clicked_position)
	NetRelay.rpc("net_sync_is_in_player2_occupy_cell_map", main_game.player2_clicked_position)
	NetRelay.rpc("net_sync_is_in_player2_arm_slot_map", main_game.player2_clicked_position)
	#await get_tree().create_timer(0.1).timeout
	print(main_game.grid_range.is_in_player2_deploy_range)
	print(main_game.grid_range.is_in_player2_occupy_cell_map)
	print(main_game.grid_range.is_in_player2_arm_slot_map)
	if main_game.grid_range.is_in_player2_deploy_range:
		print(111)
		main_game.unit_spawner.spawn_unit(main_game.player2_hand_card_be_selected_id,\
		main_game.player2_clicked_position,Data.Faction.PLAYER2)
	elif main_game.grid_range.is_in_player2_occupy_cell_map:
		print(222)
		var id = main_game.player2_hand_card_be_selected_id
		main_game.unit_spawner.spawn_unit(id,main_game.player2_clicked_position,Data.Faction.PLAYER2)
		main_game.occupancy.occupy(id,main_game.player2_clicked_position)
	elif main_game.grid_range.is_in_player2_arm_slot_map:
		print(333)
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
