extends StateBase

func _on_enter() -> void:
	main_game.current_player1_action_point -= 1
	NetRelay.rpc("net_sync_action_point", main_game.current_player1_action_point)
	
## 退出状态时触发
func _on_exit() -> void:
	pass
	
## 状态每帧更新
func _state_process(_delta: float) -> void:
	if(main_game.player2_state == Data.State.IdleState):
		parent_fsm.change_state("IdleState")

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
