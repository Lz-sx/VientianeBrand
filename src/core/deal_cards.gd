extends Node
class_name DealCards
@export var main_game: MainGame
@export var hand_root: HandRoot

var id_queue:Array[int] = []
var i:int = 0
var id_size:int = 0

func start_deal_card(faction:Data.Faction):
	if faction == Data.Faction.PLAYER1:
		main_game.player1_hand.append(0)
		#若要改成联机模式，要改
		hand_root.add_card(0)
	elif faction == Data.Faction.PLAYER2:
		main_game.player2_hand.append(0)
	await get_tree().create_timer(0.25).timeout

func deal_card_to_hand(faction:Data.Faction,draw_count_delta:int = 0):
	for ii in range(Data.DRAW_COUNT_PER_TURN+draw_count_delta):
		if i < id_size:
			i+=1
			if faction == Data.Faction.PLAYER1:
				main_game.player1_hand.append(id_queue[i])
				#若要改成联机模式，要改
				hand_root.add_card(id_queue[i])
			elif faction == Data.Faction.PLAYER2:
				main_game.player2_hand.append(id_queue[i])
		await get_tree().create_timer(0.25).timeout



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id_queue.clear()
	for k in Data.card_data.keys():
		if k != 0:
			id_queue.append(int(k))
	id_queue.shuffle()
	id_size = id_queue.size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
