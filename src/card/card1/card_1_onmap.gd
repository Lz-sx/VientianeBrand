extends Node2D

@export var hp = 20
@export var damage = 10
var Player:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hp.max_value=hp;
	$hp.value=hp;
	pass # Replace with function body.

func _init_Player(Player:int):
	self.Player = Player
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$hp.value=hp;
	if(hp<=0):
		pass
	pass
