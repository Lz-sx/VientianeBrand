extends CardBaseOnmap
class_name CharacterCardBase
var speed:int = 2
@onready var wea_icon: Sprite2D = $WeaIcon
@onready var arm_icon: Sprite2D = $ArmIcon
const BLUE_ARM = preload("res://assets/card/blue_arm.png")
const BLUE_WEA = preload("res://assets/card/blue_wea.png")
const RED_ARM = preload("res://assets/card/red_arm.png")
const RED_WEA = preload("res://assets/card/red_wea.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	

func _init_wea_arm_icon(faction:Data.Faction):
	if faction == Data.Faction.PLAYER1:
		wea_icon.texture = BLUE_WEA
		arm_icon.texture = BLUE_ARM
	elif faction == Data.Faction.PLAYER2:
		wea_icon.texture = RED_WEA
		arm_icon.texture = RED_ARM
