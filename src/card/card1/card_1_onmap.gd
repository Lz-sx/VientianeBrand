extends Node2D
@export var hp = 20
@export var damage = 10
@export var speed = 1
var Player:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hp.max_value=hp;
	$hp.value=hp;
	pass # Replace with function body.

func _init_Player(Player_:int):
	self.Player = Player_
	match Player:
		DATA.Player.PLAYER1:
			$hp.texture_over="res://assets/card/hp_player.png"
		DATA.Player.PLAYER2:
			$hp.texture_over="res://assets/card/hp_enemy.png"
		_:
			print("错误：阵营匹配")

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$hp.value=hp;
	if(hp<=0):
		pass
	pass
