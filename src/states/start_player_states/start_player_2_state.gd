extends StateBase

func _on_enter() -> void:
	if main_game.start_player == 2:
		main_game.start_player = 0
		parent_fsm.change_state("StartPlayer1State")
	else:
		parent_fsm.change_state("Player1State")
	
## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
