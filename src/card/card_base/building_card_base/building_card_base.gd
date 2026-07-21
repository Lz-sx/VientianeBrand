extends CardBaseOnmap
class_name BuildingCardBase

@onready var veh_icon: Sprite2D = $VehIcon
@onready var char_icon: Sprite2D = $CharIcon
const BLUE_VEH = preload("res://assets/card/blue_veh.png")
const BLUE_CHAR = preload("res://assets/card/blue_char.png")
const RED_CHAR = preload("res://assets/card/red_char.png")
const RED_VEH = preload("res://assets/card/red_veh.png")

var capacity:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _init_veh_char_icon(faction:Data.Faction):
	if faction == Data.Faction.PLAYER1:
		veh_icon.texture = BLUE_VEH
		char_icon.texture = BLUE_CHAR
	elif faction == Data.Faction.PLAYER2:
		veh_icon.texture = RED_VEH
		char_icon.texture = RED_CHAR
		
		
