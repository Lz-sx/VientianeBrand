extends CardBaseOnhand


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	Affiliation = Data.Affiliation.MORTAL
	Type = Data.Type.ARMOR
	id = 4
