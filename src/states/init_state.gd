extends StateBase

## 进入状态时触发
func _on_enter() -> void:
	#备份游戏初始状态
	main_game.backup_game_state()
	main_game.current_player1_action_point = 0
	main_game.current_player2_action_point = 0
	# 推进到 StartState
	parent_fsm.change_state("StartState")
