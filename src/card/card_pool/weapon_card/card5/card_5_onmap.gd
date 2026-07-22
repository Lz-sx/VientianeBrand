extends WeaponCardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 5
	Affiliation = Data.Affiliation.MORTAL
	Type = Data.Type.WEAPON
	damage_bonus = 5
	attack_range_bonus = 6
