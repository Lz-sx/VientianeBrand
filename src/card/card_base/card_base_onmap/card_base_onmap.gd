extends Node2D
class_name CardBaseOnmap
@onready var hp_line: TextureProgressBar = $Hp

@export var id:int
@export var hp = 20
@export var damage = 10
@export var attack_range = 1
@export var deployment_range = 2
var Faction:Data.Faction
@export var Affiliation:Data.Affiliation
@export var Type:Data.Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_line.max_value=hp;
	hp_line.value=hp;
	
func _init_Faction(Faction_:int):
	Faction = Faction_
	match Faction:
		Data.Faction.PLAYER1:
			$hp.texture_over="res://assets/card/hp_player1.png"
		Data.Faction.PLAYER2:
			$hp.texture_over="res://assets/card/hp_player2.png"
		_:
			print("错误：阵营匹配")

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp_line.value=hp;
	if(hp<=0):
		pass
	
