extends Node
class_name Occupancy



func embark(selected_unit:CardBaseOnmap,target_unit:CardBaseOnmap):
	if target_unit.Type == Data.Type.VEHICLE:
		target_unit = target_unit as VehicleCardBase
		if target_unit.capacity > 0 and selected_unit.Type == Data.Type.CHARACTER:
			if selected_unit.get_parent() != null:
				selected_unit.get_parent().remove_child(selected_unit)
			##waiting。。。。。。。。。。。
			target_unit.get_node("Passenger")
			
			


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
