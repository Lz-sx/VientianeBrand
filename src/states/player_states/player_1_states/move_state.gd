extends StateBase

func _on_enter() -> void:
	if main_game.grid_range.move_range.has(main_game.clicked_position):
		await main_game.movement.move(main_game.map_action_card,main_game.clicked_position)
	elif main_game.grid_range.occupy_cell_map.has(main_game.clicked_position):
		await main_game.occupancy.occupy(main_game.map_action_card,main_game.clicked_position)
	
## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
