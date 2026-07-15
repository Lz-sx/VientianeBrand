extends Node
class_name UnitSpawner

@export var data: Data
@export var container:Node
@export var map: Map

func spawn_uint(id:int, cell_position:Vector2i) -> CardBaseOnmap:
	var world_position = map.get_global_from_tile(cell_position)
	var unit = load(data.card_data[id]["map_uid"])
	var unit_instance = unit.instantiate()
	unit_instance.position = world_position
	if container:
		container.add_child(unit_instance)
	else:
		print("错误：卡牌容器")
	return unit
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
