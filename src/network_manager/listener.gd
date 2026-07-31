extends Node
class_name Listener
@onready var main_game: MainGame = $".."

func _ready() -> void:
	Events.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	NetRelay.request_select_card.connect(_on_request_select_card)
	Events.cancel_hand_card_selected.connect(_on_cancel_hand_card_selected)
	
	NetRelay.reply_release_hand_card.connect(_on_reply_release_hand_card)

#手卡选择监听
func _on_hand_card_selected_changed(card:CardBaseOnhand):
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc("net_request_select_card", card.id)

func _on_request_select_card(id:int):
	if main_game.my_faction == Data.Faction.PLAYER2:
		main_game.player2_hand_card_selected_id = id

func _on_cancel_hand_card_selected():
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc("net_request_select_card", -1)

func _on_reply_release_hand_card(id:int):
	if main_game.my_faction == Data.Faction.PLAYER2:
		var hand_card_be_selected:CardBaseOnhand = main_game.hand_root.get_card(id)
		main_game.hand_root.remove_card(hand_card_be_selected)
		main_game.hand_root.cancel_hand_card_selected()



func _input(event: InputEvent) -> void:
	if main_game.my_faction == Data.Faction.PLAYER2:
		if event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
			main_game.clicked_position = main_game.map.get_hovered_tile()
			if main_game.grid_range.deploy_range.has(main_game.clicked_position) or \
			main_game.grid_range.occupy_cell_map.has(main_game.clicked_position) or \
			main_game.grid_range.arm_slot_map.has(main_game.clicked_position) or\
			main_game.grid_range.start_range.has(main_game.clicked_position):
				NetRelay.rpc("net_request_deploy", main_game.clicked_position)
				
				
				
				
