extends Node
class_name UnitSpawner

@export var container:Node
@export var map: Map
@export var game_grid: GameGrid

func spawn_unit(id:int, cell_position:Vector2i) -> CardBaseOnmap:
	var world_position = map.get_global_from_tile(cell_position)
	# 1. 校验卡牌ID是否存在
	if not Data.card_data.has(id):
		print("错误：不存在卡牌ID ", id)
		return null
	var unit_scene: PackedScene = Data.card_data[id]["map_uid"]
	if unit_scene == null:
		print("错误：卡牌场景资源为空 ID ", id)
		return null
	# 实例化
	var unit_instance = unit_scene.instantiate()
	unit_instance.position = world_position
	# 校验容器
	if container == null:
		print("错误：卡牌容器为空")
		unit_instance.queue_free()
		return null
	container.add_child(unit_instance)
	game_grid.add_unit(unit_instance, cell_position)
	# 类型校验，防止场景挂载脚本错误
	if unit_instance is CardBaseOnmap:
		return unit_instance
	else:
		unit_instance.queue_free()
		print("错误：实例不是 CardBaseOnmap")
		return null
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
