extends TileMapLayer
class_name Map

@export var game_grid:GameGrid

func get_tile_from_global(global:Vector2) -> Vector2i:
	return local_to_map(to_global(global))
	
func get_global_from_tile(tile:Vector2) -> Vector2i:
	return to_global(map_to_local(tile))
	
func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())
