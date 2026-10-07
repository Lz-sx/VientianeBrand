extends StateBase

func _on_enter() -> void:
	NetRelay.sync_end_turn.connect(_on_sync_end_turn)
	NetRelay.rpc("net_sync_change_player2_state", Data.State.IdleState)
	NetRelay.request_player2_update_clicked_position.connect(_on_request_player2_update_clicked_position)

	
## 退出状态时触发
func _on_exit() -> void:
	NetRelay.sync_end_turn.disconnect(_on_sync_end_turn)
	NetRelay.request_player2_update_clicked_position.disconnect(_on_request_player2_update_clicked_position)

## 状态每帧更新
func _state_process(_delta: float) -> void:
	match main_game.player2_state:
		Data.State.DeployState:
			parent_fsm.change_state("DeployState")
		Data.State.AttackState:
			parent_fsm.change_state("AttackState")
		Data.State.MoveState:
			parent_fsm.change_state("MoveState")

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
				
func _on_sync_end_turn():
	parent_fsm.change_state("EndTurnState")

func _on_request_player2_update_clicked_position(position:Vector2i):
	main_game.player2_clicked_position = position	
				
