extends Node
class_name DealCards
@export var main_game: MainGame
@export var hand_root: HandRoot

var id_queue:Array[int] = []
var i:int = 0
var id_size:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetRelay.deal_cards.connect(_on_deal_cards)
	NetRelay.sync_add_hand_cards.connect(_on_sync_add_hand_cards)
	id_queue.clear()
	for k in Data.card_data.keys():
		if k != 0:
			id_queue.append(int(k))
	id_queue.shuffle()
	id_size = id_queue.size()

func start_deal_card(faction:Data.Faction):
	NetRelay.rpc("net_sync_add_hand_cards", faction, 0)
	if faction == main_game.my_faction:
		_on_deal_cards(faction, 0)
	else:
		NetRelay.rpc("net_deal_cards", faction, 0)

func _on_sync_add_hand_cards(faction:Data.Faction, card_id:int):
	if faction == Data.Faction.PLAYER1:
		main_game.player1_hand.append(card_id)
	elif faction == Data.Faction.PLAYER2:
		main_game.player2_hand.append(card_id)
	
func _on_deal_cards(faction:Data.Faction, card_id:int):
	if main_game.my_faction == faction:
		hand_root.add_card(card_id)
		await get_tree().create_timer(0.25).timeout

func deal_card_to_hand(faction:Data.Faction,draw_count_delta:int = 0):
	for ii in range(Data.DRAW_COUNT_PER_TURN+draw_count_delta):
		if i < id_size:
			
			if faction == Data.Faction.PLAYER1:
				main_game.player1_hand.append(id_queue[i])
				#若要改成联机模式，要改
				hand_root.add_card(id_queue[i])
			elif faction == Data.Faction.PLAYER2:
				main_game.player2_hand.append(id_queue[i])
			i+=1
		await get_tree().create_timer(0.25).timeout
