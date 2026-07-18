extends Node
class_name DealCards

var id_queue:Array[int] = []
var i:int = 0

func deal_card_to_hand(card_num:int):
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id_queue = Data.card_data.keys()
	id_queue.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
