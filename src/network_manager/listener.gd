extends Node
class_name Listener
@onready var main_game: MainGame = $".."

func _ready() -> void:
	Events.hand_card_selected_changed.connect(_on_hand_card_selected_changed)
	Events.map_card_selected_changed.connect(_on_map_card_selected_changed)
	Events.map_action_card_selected_changed.connect(_on_map_action_card_selected_changed)
	NetRelay.request_select_hand_card.connect(_on_request_select_hand_card)
	NetRelay.request_select_map_card.connect(_on_request_select_map_card)
	NetRelay.request_select_map_action_card.connect(_on_request_select_map_action_card)
	Events.cancel_hand_card_selected.connect(_on_cancel_hand_card_selected)

	NetRelay.reply_release_hand_card.connect(_on_reply_release_hand_card)
	NetRelay.reply_release_map_card.connect(_on_reply_release_map_card)
	
	NetRelay.sync_change_player2_state.connect(_on_sync_change_player2_state)
	NetRelay.reply_player2_deploystate_exit.connect(_on_net_reply_player2_deploystate_exit)
#手卡选择监听
func _on_hand_card_selected_changed(card:CardBaseOnhand):
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc( "net_request_select_hand_card", card.id)
		
func _on_map_card_selected_changed(card:CardBaseOnmap):
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc("net_request_select_map_card", card.id)

func _on_map_action_card_selected_changed(card:CardBaseOnmap):
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc("net_request_select_map_action_card", card.id)

func _on_request_select_hand_card(id:int):
	main_game.player2_hand_card_selected_id = id

func _on_request_select_map_card(id:int):
	main_game.player2_map_card_selected_id = id

func _on_request_select_map_action_card(id:int):
	main_game.player2_map_action_card_id = id 

func _on_cancel_hand_card_selected():
	if main_game.my_faction == Data.Faction.PLAYER2:
		NetRelay.rpc( "net_request_select_hand_card", -1)

func _on_reply_release_hand_card(id:int):
	if main_game.my_faction == Data.Faction.PLAYER2:
		var hand_card_be_selected:CardBaseOnhand = main_game.hand_root.get_card(id)
		main_game.hand_root.remove_card(hand_card_be_selected)
		main_game.hand_root.cancel_hand_card_selected()
		
func _on_reply_release_map_card(id:int):
	pass

func _on_sync_change_player2_state(state:Data.State):
	var last_state:Data.State = main_game.player2_state
	main_game.player2_state = state
	
	#if main_game.my_faction == Data.Faction.PLAYER2:
		#match state:
			#Data.State.StartTurnState:
				#pass
			#Data.State.IdleState:
				#main_game.draw_high_light_area.clear_highlight()
				#main_game.grid_range.clear()
			#Data.State.DeployState:
				#pass
			#Data.State.MoveState:
				#if main_game.map_card_be_selected != main_game.map_action_card:
					#main_game.occupancy.vacate(main_game.map_action_card)
				#if main_game.grid_range.move_range.has(main_game.clicked_position):
					#main_game.movement.move(main_game.map_action_card,main_game.clicked_position)
					#main_game.map_card_be_selected = main_game.map_action_card
					#main_game.map_card_info.update_text(main_game.map_card_be_selected)
					#if main_game.is_my_turn():
						#main_game.map_card_operate.update_button(main_game.map_card_be_selected)
				#elif main_game.grid_range.occupy_cell_map.has(main_game.clicked_position):
					#main_game.movement.move(main_game.map_action_card,main_game.clicked_position)
					#await get_tree().create_timer(0.5).timeout
					#main_game.occupancy.occupy(main_game.map_action_card.id,main_game.clicked_position)
					#main_game.map_card_be_selected = null
					#main_game.map_card_info.visible = false
					#main_game.map_card_operate.visible = false	
				#NetRelay.rpc("net_sync_change_player2_state", Data.State.IdleState)
					#
			#Data.State.AttackState:
				#await main_game.combat.attack(main_game.map_action_card,main_game.grid_range.attack_target_map\
				#[main_game.clicked_position])
				#NetRelay.rpc("net_sync_change_player2_state", Data.State.IdleState)
				#
			#Data.State.EndTurnState:
				#pass
				#
				#
		#match last_state:
			#Data.State.StartTurnState:
				#pass
			#Data.State.IdleState:
				#pass
			#Data.State.DeployState:
				#main_game.hand_root.remove_card(main_game.hand_card_be_selected)
				#main_game.hand_root.cancel_hand_card_selected()
			#Data.State.MoveState:
				#main_game.map_action_card = null
				#main_game.grid_range.clear()	
			#Data.State.AttackState:
				#main_game.map_action_card = null
			#Data.State.EndTurnState:
				#pass
				
func _on_net_reply_player2_deploystate_exit():
	if main_game.my_faction == Data.Faction.PLAYER2:
		main_game.hand_root.remove_card(main_game.hand_card_be_selected)
		main_game.hand_root.cancel_hand_card_selected()
				
func _input(_event: InputEvent) -> void:
	if main_game.my_faction == Data.Faction.PLAYER2:
		if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
			main_game.clicked_position = main_game.map.get_hovered_tile()
			if main_game.grid_range.deploy_range.has(main_game.clicked_position) or \
			main_game.grid_range.occupy_cell_map.has(main_game.clicked_position) or \
			main_game.grid_range.arm_slot_map.has(main_game.clicked_position) or\
			main_game.grid_range.start_range.has(main_game.clicked_position):
				NetRelay.rpc("net_request_deploy", main_game.clicked_position)
				
		if main_game.player2_state == Data.State.IdleState:
			if main_game.hand_card_be_selected != null:
				if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
					main_game.clicked_position = main_game.map.get_hovered_tile()
					if main_game.grid_range.deploy_range.has(main_game.clicked_position) or \
					main_game.grid_range.occupy_cell_map.has(main_game.clicked_position) or \
					main_game.grid_range.arm_slot_map.has(main_game.clicked_position):
						NetRelay.rpc("net_sync_change_player2_state", Data.State.DeployState)
			if main_game.map_card_be_selected != null and main_game.map_action_card != null:
				if _event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
					main_game.clicked_position = main_game.map.get_hovered_tile()
					if main_game.clicked_position in main_game.grid_range.attack_target_map.keys():
						NetRelay.rpc("net_sync_change_player2_state", Data.State.AttackState)
					elif main_game.clicked_position in main_game.grid_range.move_range or \
					main_game.clicked_position in main_game.grid_range.occupy_cell_map.keys():
						NetRelay.rpc("net_sync_change_player2_state", Data.State.MoveState)
						
	else:
		pass			
