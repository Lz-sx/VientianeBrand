extends Node
class_name Movement

@export var game_grid: GameGrid

func move(selected_unit:CardBaseOnmap, tile_position:Vector2i):
	selected_unit.z_index = 50
	game_grid.remove_unit_by_unit(selected_unit)
	# 缓存原始缩放，动画结束还原
	var original_scale = selected_unit.scale
	var target_world_pos = game_grid.tile_to_global(tile_position)
	# 创建Tween，串联三段动画：放大 → 移动 → 缩小
	var tween = selected_unit.create_tween()
	tween.set_ignore_tween_pause(true)
	# 第一段：快速放大 1.3倍
	tween.tween_property(selected_unit, "scale", Vector2(1.3, 1.3), 0.12)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	# 第二段：平滑移动到目标格子
	tween.tween_property(selected_unit, "position", target_world_pos, 0.3)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	# 第三段：缩小回原始大小
	tween.tween_property(selected_unit, "scale", original_scale, 0.12)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	selected_unit.z_index = 0
	# 动画全部走完后，把单位注册进网格
	tween.finished.connect(func():
		game_grid.add_unit(selected_unit,tile_position)
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
