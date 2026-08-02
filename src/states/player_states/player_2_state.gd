extends StateBase

func _on_enter() -> void:
	await get_tree().create_timer(3).timeout
	
	main_game.action_point.turn_changed_2to1()
	main_game.current_action_player = Data.Faction.PLAYER1
	parent_fsm.change_state("Player1State")
