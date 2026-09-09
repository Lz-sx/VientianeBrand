extends StateBase

func _on_enter() -> void:
	
	main_game.current_player1_action_point -= 1
	NetRelay.rpc("net_sync_action_point", main_game.current_player1_action_point)
	await main_game.combat.attack(main_game.map_action_card,main_game.grid_range.attack_target_map\
	[main_game.clicked_position])
	parent_fsm.change_state("IdleState")
## 退出状态时触发
func _on_exit() -> void:
	main_game.map_action_card = null

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
