extends ArmorCardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 4
	Affiliation = Data.Affiliation.MORTAL
	Type = Data.Type.ARMOR
	damage_reduction = 5
