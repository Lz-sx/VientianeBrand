extends Node
class_name DrawHighLightArea

@export var grid_range: GridRange
@export var high_light_area: TileMapLayer

# 高亮瓦片的来源ID和坐标
const HIGHLIGHT_SOURCE: int = 0
const HIGHLIGHT_BULE_COORDS: Vector2i = Vector2i(0, 0)
const HIGHLIGHT_RED_COORDS: Vector2i = Vector2i(1, 0)
const HIGHLIGHT_YELLOW_COORDS: Vector2i = Vector2i(0, 1)
const HIGHLIGHT_GREEN_COORDS: Vector2i = Vector2i(1, 1)

# 根据 move_grid 画高亮
func draw_move_highlight() -> void:
	clear_highlight()
	for tile_position in grid_range.move_grid:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_BULE_COORDS)
	for tile_position in grid_range.interactable_cells_and_units.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_GREEN_COORDS)

func draw_attack_highlight() -> void:
	clear_highlight()
	for tile_position in grid_range.attack_grid:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_YELLOW_COORDS)
	for tile_position in grid_range.attackable_cells_and_units.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_RED_COORDS)
	
# 清除所有高亮
func clear_highlight() -> void:
	high_light_area.clear()


func _ready() -> void:
	
	pass # Replace with function body.
