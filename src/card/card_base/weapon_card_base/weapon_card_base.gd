extends Node2D

class_name WeaponCardBase

var id:int
var damage_bonus = 5
var attack_range_bonus = 2

var Affiliation:Data.Affiliation = Data.Affiliation.MORTAL
var Type:Data.Type = Data.Type.WEAPON

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

	
