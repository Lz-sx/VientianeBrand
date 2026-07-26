extends StateBase

func _on_enter() -> void:
	await get_tree().create_timer(1).timeout
	main_game.unit_spawner.spawn_unit(0,Vector2i(0,0),Data.Faction.PLAYER2)
	await get_tree().create_timer(1).timeout
	main_game.unit_spawner.spawn_unit(3,Vector2i(0,1),Data.Faction.PLAYER2)
	var card_on_map:CardBaseOnmap = main_game.unit_spawner.spawn_unit(1,Vector2i(0,0)\
	,Data.Faction.PLAYER2)
	main_game.occupancy.occupy(card_on_map,Vector2i(0,0))
	await get_tree().create_timer(1).timeout
	card_on_map = main_game.unit_spawner.spawn_unit(2,Vector2i(0,0),Data.Faction.PLAYER2)
	main_game.occupancy.occupy(card_on_map,Vector2i(0,0))
	await get_tree().create_timer(1).timeout
	main_game.grid_range.find_active_unit_map()
	main_game.arm.spawn_and_equip_weapon(5,Data.Type.WEAPON,Vector2i(0,0))
	await get_tree().create_timer(1).timeout
	main_game.arm.spawn_and_equip_weapon(4,Data.Type.ARMOR,Vector2i(0,0))
	
	if main_game.start_player == 2:
		main_game.start_player = 0
		parent_fsm.change_state("StartPlayer1State")
	else:
		parent_fsm.change_state("Player1State")
		main_game.action_point._init_turn(Data.Faction.PLAYER1)
## 退出状态时触发
func _on_exit() -> void:
	pass

## 状态每帧更新
func _state_process(_delta: float) -> void:
	pass

## 状态处理输入事件
func _state_input(_event: InputEvent) -> void:
	pass
