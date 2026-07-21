extends BuildingCardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 3
	Affiliation = Data.Affiliation.MORTAL
	Type = Data.Type.BUILDING
	hp = 30
	damage = 10
	attack_range = 6
	capacity = 1
	deployment_range = 2
