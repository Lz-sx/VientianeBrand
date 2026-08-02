extends StateBase

func _on_enter() -> void:
	await main_game.deal_cards.deal_card_to_hand(Data.Faction.PLAYER1,\
	main_game.player1_draw_count_delta)	
	main_game.current_player1_action_point += main_game.DEFALUT_ACTION_POINT
	if main_game.current_player1_action_point > main_game.MAX_ACTION_POINT:
		main_game.current_player1_action_point = main_game.MAX_ACTION_POINT
	NetRelay.rpc("_on_sync_action_point", main_game.current_player1_action_point)
	NetRelay.rpc("net_sync_turn_change", Data.Faction.PLAYER1)
	parent_fsm.change_state("IdleState")

## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
