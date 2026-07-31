extends Node

# 定义同步信号
signal sync_main_init
signal sync_action_point(player:Data.Faction, value:int)
signal deal_cards(player:Data.Faction, card_id:int)
signal sync_add_hand_cards(player:Data.Faction, card_id:int)
signal sync_spawn_unit(id:int, cell_position:Vector2i, faction:Data.Faction)

signal sync_turn_change(faction)
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


@rpc("call_remote", "reliable")
func net_deal_cards(player:Data.Faction, card_id:int):
	emit_signal("deal_cards", player, card_id)
