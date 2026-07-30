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
		
func start_judge_authority():
	var rand_res = randi_range(0,1)
	var winner_faction:Data.Faction = Data.Faction.NULL
	if rand_res == 0:
		winner_faction = Data.Faction.PLAYER1
	else:
		winner_faction = Data.Faction.PLAYER2
	# 广播结果，让所有人同步播放动画
	rpc("sync_start_coin_flip", rand_res)
	return winner_faction
	
# ==========【两端都会执行：硬币动画表现】==========
@rpc("any_peer", "call_local", "reliable")
func sync_start_coin_flip(rand_res:int):
	# 两边同时生成硬币、播放动画
	var coin:Coin = COIN.instantiate()
	hand_layer.add_child(coin)
	
	await get_tree().create_timer(0.1).timeout
	coin.show_flip_coin()
	
	await get_tree().create_timer(2).timeout
	
	if rand_res == 0:
		coin.show_blue_side()
		await get_tree().create_timer(1.5).timeout
	else:
		coin.show_red_side()
		await get_tree().create_timer(1.5).timeout
	
	coin.fade_out()
	coin.queue_free()
