extends Node2D
class_name CardBaseOnmap
@onready var hp_line: TextureProgressBar = $Hp
@onready var shield_texture: Sprite2D = $ShieldTexture
@onready var shield_value: Label = $ShieldValue
const HP_PLAYER_1 = preload("uid://f5fldqfgynru")
const HP_PLAYER_2 = preload("uid://dvodbnjdpsjfw")

@export var id:int
@export var hp = 20
@export var damage = 10
@export var attack_range = 1
@export var deployment_range = 2
var shield:int = 0

var Faction:Data.Faction = Data.Faction.PLAYER1
var Affiliation:Data.Affiliation = Data.Affiliation.MORTAL
var Type:Data.Type = Data.Type.CHARACTER


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_line.max_value=hp;
	hp_line.value=hp;
	
func _init_Faction(Faction_:int):
	Faction = Faction_
	hp_line = $Hp
	match Faction:
		Data.Faction.PLAYER1:
			hp_line.texture_progress = HP_PLAYER_1
		Data.Faction.PLAYER2:
			hp_line.texture_progress = HP_PLAYER_2
		_:
			print("错误：阵营匹配")


func shield_on():
	shield_texture.visible = true
	shield_value.visible = true

func shield_off():
	shield_texture.visible = false
	shield_value.visible = false
	
func update_shield():
	if shield <= 0:
		#动画
		shield = 0
		shield_off()
	else:
		#动画
		shield_on()
		shield_value.text = "%d" %shield

func update_hp():
	if hp > 0:
		hp_line.value=hp
	else:
		hp = 0
		hp_line.value=0
		
func shield_and_hp_on():
	shield_on()
	hp_line.visible = true
	
func shield_and_hp_off():
	shield_off()
	hp_line.visible = false
