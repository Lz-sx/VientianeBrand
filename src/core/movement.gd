extends Node
class_name Movement

@export var game_grid: GameGrid
@export var map: Map
@onready var obstacle: TileMapLayer = $"../Map/Obstacle"


func move(selected_unit:CardBaseOnmap, tile_position:Vector2i):
	selected_unit.z_index = 50
	game_grid.remove_unit_by_unit(selected_unit)
	# 缓存原始缩放，动画结束还原
	var original_scale = selected_unit.scale
	var target_world_pos = map.get_global_from_tile(tile_position)
	print("当前卡牌坐标：", selected_unit.global_position)
	print("目标格子世界坐标：", target_world_pos)
	var tween:Tween = get_tree().root.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(selected_unit, "scale", Vector2(1.3, 1.3), 0.12)
	tween.tween_property(selected_unit, "global_position", target_world_pos, 0.3)
	tween.tween_property(selected_unit, "scale", original_scale, 0.12)

	# 新增：动画运行期间持续打印坐标
	await get_tree().create_timer(0.15).timeout
	print("动画进行中卡牌坐标：", selected_unit.global_position)
	
	# 动画全部走完后，把单位注册进网格
	tween.finished.connect(func():
		selected_unit.z_index = 0
		game_grid.add_unit(selected_unit,tile_position)
	)
