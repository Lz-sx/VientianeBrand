extends Node
class_name DrawHighLightArea

@export var grid_range: GridRange
@export var high_light_area: TileMapLayer
@onready var main_game: MainGame = $"../.."

# 高亮瓦片的来源ID和坐标
const HIGHLIGHT_SOURCE: int = 0
const HIGHLIGHT_BULE_COORDS: Vector2i = Vector2i(0, 0)
const HIGHLIGHT_RED_COORDS: Vector2i = Vector2i(1, 0)
const HIGHLIGHT_YELLOW_COORDS: Vector2i = Vector2i(0, 1)
const HIGHLIGHT_GREEN_COORDS: Vector2i = Vector2i(1, 1)


func _ready() -> void:
	Events.deploy_range_found.connect(_on_deploy_range_found)
	Events.deploy_range_clear.connect(_on_deploy_range_clear)
	
	Events.attack_range_found.connect(_on_attack_range_found)
	Events.move_range_found.connect(_on_move_range_found)
	
func _on_deploy_range_found(new_card:CardBaseOnhand):
	if main_game.is_my_turn():
		if new_card.id == 0 or new_card.id == 1:
			draw_start_highlight()
		else:
			draw_deploy_highlight()
	

func _on_deploy_range_clear():
	clear_highlight()
	
func _on_attack_range_found():
	draw_attack_highlight()

func _on_move_range_found():
	draw_move_highlight()
	
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
