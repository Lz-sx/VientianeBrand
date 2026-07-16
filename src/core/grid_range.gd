extends Node
class_name  GridRange

@export var game_grid: GameGrid

var attack_grid:Array[Vector2i]
var move_grid:Array[Vector2i]

var unit_in_attack_grid:Array[Vector2i]
var unit_in_move_grid:Array[Vector2i]


func get_cells_in_range(center: Vector2i, range: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []	
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if abs(x) + abs(y) <= range:
				cells.append(center + Vector2i(x, y))
	return cells
	
# 四个方向：上下左右
const DIRS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
]

func find_move_range(center: Vector2i, speed: int) -> void:
	move_grid.clear()
	unit_in_move_grid.clear()
	# BFS 队列：存 [坐标, 已走步数]
	var queue: Array = [[center, 0]]
	# 记录已访问的格子，避免重复
	var visited: Dictionary = {center: true}
	while queue.size() > 0:
		var current = queue.pop_front()
		var pos: Vector2i = current[0]
		var steps: int = current[1]
		move_grid.append(pos)  # 可达格子加入结果
		# 步数到上限就不再扩展
		if steps >= speed:
			continue
		# 扩展四个方向
		for dir in DIRS:
			var next_pos: Vector2i = pos + dir
			# 已经访问过就跳过
			if visited.has(next_pos):
				continue
			# 判断障碍物：有单位就不能走
			if game_grid.grid_data[next_pos]["unit"] != null:
				unit_in_move_grid.append(game_grid.grid_data[next_pos]["unit"])
				continue
			visited[next_pos] = true
			queue.append([next_pos, steps + 1])

func find_attack_range(center: Vector2i, range: int):
	attack_grid.clear()
	unit_in_attack_grid.clear()
	attack_grid = get_cells_in_range(center,range)
	for position in attack_grid:
		if game_grid.grid_data[position]["unit"] != null:
			unit_in_attack_grid.append(game_grid.grid_data[position]["unit"])
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
