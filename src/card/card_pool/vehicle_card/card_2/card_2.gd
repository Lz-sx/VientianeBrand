extends VehicleCardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 2
	Affiliation = Data.Affiliation.MORTAL
	Type = Data.Type.VEHICLE
	hp = 20
	damage = 5
	attack_range = 1
	speed = 5
	capacity = 1
	deployment_range = 1
