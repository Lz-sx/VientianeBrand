extends StateBase

## 进入状态时触发
func _on_enter() -> void:
	#备份游戏初始状态
	main_game.backup_game_state()
	NetRelay.rpc("sync_action_point",Data.Faction.PLAYER1,0)
	NetRelay.rpc("sync_action_point",Data.Faction.PLAYER2,0)
	# 推进到 StartState
	parent_fsm.change_state("StartState")
