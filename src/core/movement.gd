extends Node
class_name Movement

@export var game_grid: GameGrid
@export var map: Map
@onready var obstacle: TileMapLayer = $"../Map/Obstacle"
@onready var main_game: MainGame = $".."

var is_player1_move_over:bool = false
var is_player2_move_over:bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	NetRelay.sync_move.connect(_on_sync_move)
	NetRelay.sync_is_move_over.connect(_on_sync_is_move_over)

func _on_sync_is_move_over(faction:Data.Faction,temp:bool):
	if faction == Data.Faction.PLAYER1:
		is_player1_move_over = temp
	elif faction == Data.Faction.PLAYER2:
		is_player2_move_over = temp

func _on_sync_move(selected_unit_id: int, tile_position: Vector2i):
	var selected_unit = main_game.id_map_card_map[selected_unit_id]
	selected_unit.z_index = 50
	game_grid.remove_unit_by_unit(selected_unit)
	var target_world_pos = map.get_global_from_tile(tile_position)
	var original_scale = selected_unit.scale
	# 关键：把世界坐标转为相对于父节点的局部坐标
	var parent_node = selected_unit.get_parent()
	var local_target = parent_node.to_local(target_world_pos)
	var tween :Tween= selected_unit.create_tween()
	if selected_unit.Type == Data.Type.VEHICLE:
		selected_unit = selected_unit as VehicleCardBase
		if selected_unit.capacity != Data.card_data[selected_unit.id]["capacity"]:
			for child in selected_unit.get_node("Passenger").get_children():
				child.position = local_target
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(selected_unit, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(selected_unit, "position", local_target, 0.3)  # 动画 position
	tween.tween_property(selected_unit, "scale", original_scale, 0.1)
	tween.finished.connect(func():
		selected_unit.z_index = 0
		game_grid.add_unit(selected_unit, tile_position)
		NetRelay.rpc("net_sync_is_move_over", main_game.my_faction, true)
	)

func move_by_unit(selected_unit: CardBaseOnmap, tile_position: Vector2i):
	NetRelay.rpc("net_sync_move", selected_unit.id, tile_position)

func move_by_id(id:int, tile_position: Vector2i):
	NetRelay.rpc("net_sync_move", id, tile_position)
