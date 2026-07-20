extends StateBase

func _on_enter() -> void:
	parent_fsm.change_state("Player1State")
