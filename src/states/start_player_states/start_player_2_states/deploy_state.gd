extends StateBase

func _on_enter() -> void:
	main_game.unit_spawner.spawn_unit(0,main_game.player2_clicked_position,Data.Faction.PLAYER2)
	parent_fsm.change_state("EndTurnState")
	
## 退出状态时触发
func _on_exit() -> void:
	NetRelay.rpc("net_reply_release_hand_card",main_game.player2_hand_card_selected_id)
	
## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass

	
