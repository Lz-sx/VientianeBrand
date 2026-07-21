extends CardBaseOnmap
class_name VehicleCardBase

var speed:int = 3
var capacity:int = 1
@onready var char_icon: Sprite2D = $CharIcon
const BLUE_CHAR = preload("res://assets/card/blue_char.png")
const RED_CHAR = preload("res://assets/card/red_char.png")

func _ready() -> void:
	super._ready()

func _init_wea_arm_icon(faction:Data.Faction):
	if faction == Data.Faction.PLAYER1:
		char_icon.texture = BLUE_CHAR
	elif faction == Data.Faction.PLAYER2:
		char_icon.texture = RED_CHAR
