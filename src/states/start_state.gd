extends StateBase

func _on_enter() -> void:
	var faction = await main_game.turn_judge_manager.start_judge()
	if faction == Data.Faction.PLAYER1:
		main_game.start_player = 1
		parent_fsm.change_state("StartPlayer1State")
	elif faction == Data.Faction.PLAYER2:
		main_game.start_player = 2
		parent_fsm.change_state("StartPlayer2State")
