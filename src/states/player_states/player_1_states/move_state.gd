extends StateBase

func _on_enter() -> void:
	
	main_game.current_player1_action_point -= 1
	NetRelay.rpc("net_sync_action_point_show", main_game.current_player1_action_point)
	
	if main_game.map_card_be_selected != main_game.map_action_card:
		print("出")
		main_game.occupancy.is_player1_vacate_over = false
		main_game.occupancy.is_player2_vacate_over = false
		main_game.occupancy.vacate_by_unit(main_game.map_action_card)
		print("等待")
		while not (main_game.occupancy.is_player1_vacate_over\
		and main_game.occupancy.is_player2_vacate_over):
			await get_tree().process_frame
		main_game.occupancy.is_player1_vacate_over = false
		main_game.occupancy.is_player2_vacate_over = false
		print("等待结束")
	if main_game.grid_range.move_range.has(main_game.clicked_position):
		print("开始移动")
		main_game.movement.is_player1_move_over = false
		main_game.movement.is_player2_move_over = false
		main_game.movement.move_by_unit(main_game.map_action_card,main_game.clicked_position)
		print("等待")
		while not (main_game.movement.is_player1_move_over\
		and main_game.movement.is_player2_move_over):
			await get_tree().process_frame
		main_game.movement.is_player1_move_over = false
		main_game.movement.is_player2_move_over = false
		print("等待结束")
		main_game.map_card_be_selected = main_game.map_action_card
		main_game.map_card_info.update_text(main_game.map_card_be_selected)
		if main_game.is_my_turn():
			main_game.map_card_operate.update_button(main_game.map_card_be_selected)
	elif main_game.grid_range.occupy_cell_map.has(main_game.clicked_position):
		
		main_game.movement.is_player1_move_over = false
		main_game.movement.is_player2_move_over = false
		print("开始移动")
		main_game.movement.move_by_unit(main_game.map_action_card,main_game.clicked_position)
		#await get_tree().create_timer(0.5).timeout
		print("等待")
		while not (main_game.movement.is_player1_move_over\
		and main_game.movement.is_player2_move_over):
			await get_tree().process_frame
		main_game.movement.is_player1_move_over = false
		main_game.movement.is_player2_move_over = false
		print("等待结束")
		print("占据")
		main_game.occupancy.occupy(main_game.map_action_card.id,main_game.clicked_position)
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
