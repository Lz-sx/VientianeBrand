extends Node

# 定义同步信号
signal sync_main_init
signal sync_action_point_show(value:int)
signal sync_action_point(player:Data.Faction, value:int)
signal deal_cards(player:Data.Faction, card_id:int)
signal sync_add_hand_cards(player:Data.Faction, card_id:int)
signal sync_spawn_unit(id:int, cell_position:Vector2i, faction:Data.Faction)
signal request_select_hand_card(id:int)
signal request_select_map_card(id:int)
signal request_select_map_action_card(id:int)
signal request_player2_update_clicked_position(position:Vector2i)
signal reply_release_hand_card(id:int)
signal reply_release_map_card()
signal reply_player2_update_text(id:int)
signal reply_player2_update_button(id:int)
signal reply_attack(id:int, pos:Vector2i)
signal sync_turn_change(faction:Data.Faction)
signal sync_init_turn(faction:Data.Faction)
signal sync_occupy(id:int, position:Vector2i)
signal sync_spawn_and_equip_weapon(id:int, arm_type:Data.Type, pos:Vector2i)
signal sync_attack(selected_unit_id:int,target_unit_id:int)
signal sync_vacate(selected_unit_id:int)
signal sync_move(selected_unit_id: int, tile_position: Vector2i)
signal sync_end_turn
signal sync_show_turn_operate(faction:Data.Faction,mode:bool)
signal sync_change_player2_state(state:Data.State)
signal reply_player2_idlestate_enter
signal reply_player2_deploystate_exit
signal reply_player2_movestate_exit
signal sync_is_in_player2_move_range(temp:bool)
signal sync_is_in_player2_occupy_cell_map(temp:bool)
signal sync_is_in_player2_deploy_range(temp:bool)
signal sync_is_in_player2_arm_slot_map(temp:bool)
signal sync_is_vacate_over(faction:Data.Faction,temp:bool)
signal sync_is_move_over(faction:Data.Faction,temp:bool)
signal request_is_in_player2_move_range(pos:Vector2i)
signal request_is_in_player2_occupy_cell_map(pos:Vector2i)
signal request_is_in_player2_deploy_range(pos:Vector2i)
signal request_is_in_player2_arm_slot_map(pos:Vector2i)
signal sync_unit_pos(unit_id:int, pos:Vector2i)

#两端->两端
@rpc("any_peer", "call_local", "reliable")
func net_sync_main_init() -> void:
	emit_signal("sync_main_init")
	
# RPC函数，收到网络消息只发射信号，不访问场景节点
@rpc("any_peer", "call_local", "reliable")
func net_sync_action_point_show(value:int):
	emit_signal("sync_action_point_show",value)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_action_point(player:Data.Faction, value:int):
	emit_signal("sync_action_point",player,value)

@rpc("any_peer", "call_local", "reliable")
func net_sync_add_hand_cards(player:Data.Faction, card_id:int):
	emit_signal("sync_add_hand_cards", player, card_id)

@rpc("any_peer", "call_local", "reliable")
func net_sync_spawn_unit(id:int, cell_position:Vector2i, faction:Data.Faction):
	emit_signal("sync_spawn_unit", id, cell_position, faction)

@rpc("any_peer", "call_local", "reliable")
func net_sync_turn_change(faction:Data.Faction):
	emit_signal("sync_turn_change", faction)

@rpc("any_peer", "call_local", "reliable")
func net_sync_update_point(action_point:int):
	emit_signal("sync_update_point", action_point)

@rpc("any_peer", "call_local", "reliable")
func net_sync_init_turn(faction:Data.Faction):
	emit_signal("sync_init_turn", faction)

@rpc("any_peer", "call_local", "reliable")
func net_sync_occupy(id:int, position:Vector2i):
	emit_signal("sync_occupy", id, position)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_spawn_and_equip_weapon(id:int, arm_type:Data.Type, pos:Vector2i):
	emit_signal("sync_spawn_and_equip_weapon", id, arm_type,pos)

@rpc("any_peer", "call_local", "reliable")
func net_sync_attack(selected_unit_id:int,target_unit_id:int):
	emit_signal("sync_attack", selected_unit_id, target_unit_id)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_vacate(selected_unit_id:int):
	emit_signal("sync_vacate", selected_unit_id)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_move(selected_unit_id: int, tile_position: Vector2i):
	emit_signal("sync_move", selected_unit_id, tile_position)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_end_turn() -> void:
	emit_signal("sync_end_turn")
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_show_turn_operate(faction:Data.Faction, mode:bool) -> void:
	emit_signal("sync_show_turn_operate", faction, mode)	

@rpc("any_peer", "call_local", "reliable")
func net_sync_change_player2_state(state:Data.State) -> void:
	emit_signal("sync_change_player2_state", state)

@rpc("any_peer", "call_local", "reliable")
func net_sync_is_in_player2_move_range(temp:bool) -> void:
	emit_signal("sync_is_in_player2_move_range", temp)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_is_in_player2_occupy_cell_map(temp:bool) -> void:
	emit_signal("sync_is_in_player2_occupy_cell_map", temp)

@rpc("any_peer", "call_local", "reliable")
func net_sync_is_in_player2_deploy_range(temp:bool) -> void:
	emit_signal("sync_is_in_player2_deploy_range", temp)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_is_in_player2_arm_slot_map(temp:bool) -> void:
	emit_signal("sync_is_in_player2_arm_slot_map", temp)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_is_vacate_over(faction:Data.Faction,temp:bool) -> void:
	emit_signal("sync_is_vacate_over", faction,temp)
	
@rpc("any_peer", "call_local", "reliable")
func net_sync_is_move_over(faction:Data.Faction,temp:bool) -> void:
	emit_signal("sync_is_move_over", faction,temp)



@rpc("call_remote", "reliable")
func net_deal_cards(player:Data.Faction, card_id:int):
	emit_signal("deal_cards", player, card_id)

@rpc("call_remote", "reliable")
func net_reply_release_hand_card(id:int):
	emit_signal("reply_release_hand_card",id)

@rpc("call_remote", "reliable")
func net_reply_release_map_card():
	emit_signal("reply_release_map_card")
	
@rpc("call_remote", "reliable")
func net_reply_release_map_action_card(id:int):
	emit_signal("reply_release_map_action_card",id)

@rpc("call_remote", "reliable")
func net_reply_player2_idlestate_enter():
	emit_signal("reply_player2_idlestate_enter")

@rpc("call_remote", "reliable")
func net_reply_player2_deploystate_exit():
	emit_signal("reply_player2_deploystate_exit")

@rpc("call_remote", "reliable")
func net_reply_player2_movestate_exit():
	emit_signal("reply_player2_movestate_exit")

@rpc("call_remote", "reliable")
func net_reply_player2_update_text(id:int):
	emit_signal("reply_player2_update_text",id)

@rpc("call_remote", "reliable")
func net_reply_player2_update_button(id:int):
	emit_signal("reply_player2_update_button",id)

@rpc("call_remote", "reliable")
func net_reply_attack(id:int, pos:Vector2i):
	emit_signal("reply_attack",id, pos)






@rpc("any_peer", "call_remote", "reliable")
func net_request_select_hand_card(id:int):
	emit_signal("request_select_hand_card", id)

@rpc("any_peer", "call_remote", "reliable")
func net_request_select_map_card(id:int):
	emit_signal("request_select_map_card", id)

@rpc("any_peer", "call_remote", "reliable")
func net_request_select_map_action_card(id:int):
	emit_signal("request_select_map_action_card", id)

@rpc("any_peer", "call_remote", "reliable")
func net_request_player2_update_clicked_position(position:Vector2i):
	emit_signal("request_player2_update_clicked_position", position)
	
@rpc("any_peer", "call_remote", "reliable")
func net_request_is_in_player2_move_range(position:Vector2i):
	emit_signal("request_is_in_player2_move_range", position)
	
@rpc("any_peer", "call_local", "reliable")
func net_request_is_in_player2_occupy_cell_map(pos:Vector2i) -> void:
	emit_signal("request_is_in_player2_occupy_cell_map", pos)

@rpc("any_peer", "call_local", "reliable")
func net_request_is_in_player2_deploy_range(pos:Vector2i) -> void:
	emit_signal("request_is_in_player2_deploy_range", pos)
	
@rpc("any_peer", "call_local", "reliable")
func net_request_is_in_player2_arm_slot_map(pos:Vector2i) -> void:
	emit_signal("request_is_in_player2_arm_slot_map", pos)
