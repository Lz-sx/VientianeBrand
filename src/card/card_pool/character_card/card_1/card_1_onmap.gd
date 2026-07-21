extends CharacterCardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 1
	Affiliation = Data.Affiliation.MORTAL
	Type =  Data.Type.CHARACTER
	hp = 20
	damage = 10
	attack_range = 1
	speed = 2
	deployment_range = 1
