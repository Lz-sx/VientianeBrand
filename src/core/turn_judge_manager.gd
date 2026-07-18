extends Node
class_name TurnJudgeManager

const COIN = preload("uid://t2hov3sjydyh")
@export var hand_layer: CanvasLayer

func start_judge() -> Data.Faction:
	var coin:Coin = COIN.instantiate()
	hand_layer.add_child(coin)
	await get_tree().create_timer(0.1).timeout
	coin.show_flip_coin()
	var rand_res = randi_range(0,1)
	var first_player:int = rand_res
	await get_tree().create_timer(2).timeout
	if first_player == 0:
		coin.show_blue_side()
		await get_tree().create_timer(1.5).timeout
		coin.fade_out()
		coin.queue_free()
		return Data.Faction.PLAYER1
	else:
		coin.show_red_side()
		await get_tree().create_timer(1.5).timeout
		coin.fade_out()
		coin.queue_free()
		return Data.Faction.PLAYER2

func _ready() -> void:
	randomize()
	# 延迟一帧再启动判定，避免实例时序问题
	await get_tree().process_frame
	start_judge()
