extends Control
class_name TurnOperate

@onready var main_game: MainGame = $"../.."

func _ready() -> void:
	NetRelay.sync_show_turn_operate.connect(_on_sync_show_turn_operate)
	
func _on_sync_show_turn_operate(faction:Data.Faction, mode:bool):
	if faction == main_game.my_faction:
		if mode == true:
			visible = true
		elif mode == false:
			visible = false

func _on_end_turn_pressed() -> void:
	NetRelay.rpc("net_sync_end_turn")
