extends Node

# 定义同步信号
signal sync_main_init
signal sync_action_point(player:Data.Faction, value:int)
signal deal_cards(player:Data.Faction, card_id:int)
signal sync_add_hand_cards(player:Data.Faction, card_id:int)
signal sync_spawn_unit(id:int, cell_position:Vector2i, faction:Data.Faction)
signal request_select_card(id:int)
signal request_deploy(position:Vector2i)
signal reply_release_hand_card(id:int)
signal sync_turn_change(faction:Data.Faction)


signal sync_unit_pos(unit_id:int, pos:Vector2i)

@rpc("any_peer", "call_local", "reliable")
func net_sync_main_init() -> void:
	emit_signal("sync_main_init")
	
# RPC函数，收到网络消息只发射信号，不访问场景节点
@rpc("any_peer", "call_local", "reliable")
func net_sync_action_point(player:Data.Faction, value:int):
	emit_signal("sync_action_point", player, value)

@rpc("any_peer", "call_local", "reliable")
func net_sync_add_hand_cards(player:Data.Faction, card_id:int):
	emit_signal("sync_add_hand_cards", player, card_id)

@rpc("any_peer", "call_local", "reliable")
func net_sync_spawn_unit(id:int, cell_position:Vector2i, faction:Data.Faction):
	emit_signal("sync_spawn_unit", id, cell_position, faction)

@rpc("any_peer", "call_local", "reliable")
func net_sync_turn_change(faction:Data.Faction):
	emit_signal("sync_turn_change", faction)




@rpc("call_remote", "reliable")
func net_deal_cards(player:Data.Faction, card_id:int):
	emit_signal("deal_cards", player, card_id)

@rpc("call_remote", "reliable")
func _net_reply_release_hand_card(id:int):
	emit_signal("reply_release_hand_card",id)



@rpc("authority", "reliable")
func net_request_select_card(id:int):
	print(5656)
	emit_signal("request_select_card", id)
	
@rpc("authority", "reliable")
func net_request_deploy(position:Vector2i):
	print(1234)
	emit_signal("request_deploy", position)
