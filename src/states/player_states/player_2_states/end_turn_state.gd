extends StateBase

func _on_enter() -> void:
	parent_fsm.parent_fsm.change_state("Player1State")
	NetRelay.rpc("net_sync_init_turn", Data.Faction.PLAYER1)
	NetRelay.rpc("net_sync_show_turn_operate",Data.Faction.PLAYER2, false)
	
## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
