extends StateBase

func _on_enter() -> void:
	var faction = await main_game.turn_judge_manager.start_judge()
	if faction == Data.Faction.PLAYER1:
		parent_fsm.change_state("Player1State")
	elif faction == Data.Faction.PLAYER2:
		parent_fsm.change_state("Player2State")
