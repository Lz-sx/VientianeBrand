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
func draw_start_highlight():
	clear_highlight()
	for tile_position in grid_range.start_range:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_BULE_COORDS)

func draw_move_highlight() -> void:
	clear_highlight()
	for tile_position in grid_range.move_range:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_BULE_COORDS)
	for tile_position in grid_range.occupy_cell_map.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_GREEN_COORDS)

func draw_attack_highlight() -> void:
	clear_highlight()
	for tile_position in grid_range.attack_range:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_YELLOW_COORDS)
	for tile_position in grid_range.attack_target_map.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_RED_COORDS)

func draw_deploy_highlight():
	clear_highlight()
	for tile_position in grid_range.deploy_range:
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_BULE_COORDS)
	for tile_position in grid_range.occupy_cell_map.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_GREEN_COORDS)
		
	#武装在这里
	for tile_position in grid_range.arm_slot_map.keys():
		high_light_area.set_cell(tile_position, HIGHLIGHT_SOURCE, HIGHLIGHT_GREEN_COORDS)

# 清除所有高亮
func clear_highlight() -> void:
	high_light_area.clear()


func _ready() -> void:
	
	pass # Replace with function body.
