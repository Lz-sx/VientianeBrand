extends StateBase

func _on_enter() -> void:
	NetRelay.request_deploy.connect(_on_request_deploy)
	main_game.draw_high_light_area.clear_highlight()
	main_game.grid_range.clear()

## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass

func _on_request_deploy(position:Vector2i):
	main_game.player2_clicked_position = position
	parent_fsm.change_state("DeployState")
