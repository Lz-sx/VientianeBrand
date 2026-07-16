extends Node
class_name Occupancy
@export var grid_range: GridRange
@export var game_grid: GameGrid

func embark(seleced_unit:CardBaseOnmap,target_unit:CardBaseOnmap):
	game_grid.remove_unit(grid_range.occupancy_cells_and_units.find_key(seleced_unit))
	



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
