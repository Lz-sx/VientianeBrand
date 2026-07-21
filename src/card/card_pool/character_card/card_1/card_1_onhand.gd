extends CardBaseOnhand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	id = 1
	Affiliation = Data.Affiliation.MORTAL
	Type =  Data.Type.CHARACTER
