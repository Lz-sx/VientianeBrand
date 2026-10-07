extends StateBase

func _on_enter() -> void:
	NetRelay.rpc("net_sync_change_player2_state", Data.State.StartIdleState)
	NetRelay.request_player2_update_clicked_position.connect(_on_request_player2_update_clicked_position)
	main_game.draw_high_light_area.clear_highlight()
	main_game.grid_range.clear()
	
## 退出状态时触发
func _on_exit() -> void:
	NetRelay.request_player2_update_clicked_position.disconnect(_on_request_player2_update_clicked_position)

## 状态每帧更新
func _state_process(_delta: float) -> void:
	match main_game.player2_state:
		Data.State.StartDeployState:
			parent_fsm.change_state("DeployState")

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass

func _on_request_player2_update_clicked_position(position:Vector2i):
	main_game.player2_clicked_position = position
	
