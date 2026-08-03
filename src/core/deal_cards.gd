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
		if k != 0 and k != 1 :
			id_queue.append(int(k))
	id_queue.shuffle()
	id_size = id_queue.size()

func start_deal_card(faction:Data.Faction):
	if faction == Data.Faction.PLAYER1:
		NetRelay.rpc("net_sync_add_hand_cards", faction, 0)
		_on_deal_cards(faction, 0)
	elif faction == Data.Faction.PLAYER2:
		NetRelay.rpc("net_sync_add_hand_cards", faction, 1)
		NetRelay.rpc("net_deal_cards", faction, 1)
			
			 
func _on_sync_add_hand_cards(faction:Data.Faction, card_id:int):
	if faction == Data.Faction.PLAYER1:
		main_game.player1_hand.append(card_id)
	elif faction == Data.Faction.PLAYER2:
		main_game.player2_hand.append(card_id)
	
func _on_deal_cards(faction:Data.Faction, card_id:int):
	if main_game.my_faction == faction:
		hand_root.add_card(card_id)
		await get_tree().create_timer(0.25).timeout



#未修改
func deal_card_to_hand(faction:Data.Faction,draw_count_delta:int = 0):
	for ii in range(Data.DRAW_COUNT_PER_TURN+draw_count_delta):
		if i < id_size:
			NetRelay.rpc("net_sync_add_hand_cards", faction, id_queue[i])
			if faction == main_game.my_faction:
				_on_deal_cards(faction, id_queue[i])
			else:
				NetRelay.rpc("net_deal_cards", faction, id_queue[i])
			i+=1
		await get_tree().create_timer(0.25).timeout
