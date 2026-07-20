extends Node
class_name  ARM

func spawn_and_equip_weapon(id:int, type:Data.Type, target_card:CardBaseOnmap) -> CardBaseOnmap:
	if not Data.card_data.has(id):
		print("错误：不存在卡牌ID ", id)
		return null
	var unit_scene: PackedScene = Data.card_data[id]["map_uid"]
	if unit_scene == null:
		print("错误：卡牌场景资源为空 ID ", id)
		return null
	# 实例化
	var unit_instance = unit_scene.instantiate()
	if type == Data.Type.WEAPON:
		target_card.get_node("Weapon").add_child(unit_instance)
	if type == Data.Type.ARMOR:
		target_card.get_node("ARMOR").add_child(unit_instance)
	return unit_instance
