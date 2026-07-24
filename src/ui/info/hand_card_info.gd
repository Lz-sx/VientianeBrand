extends Control
class_name HandCardInfo
@export var rich_text_label: RichTextLabel

func show_hand_panel(id:int):
	if not Data.card_data.has(id):
		rich_text_label.text = "卡牌不存在"
		return
	
	var card = Data.card_data[id]
	var text = ""
	
	text += "名称：%s\n" % card["name"]
	
	var type_map = {
		Data.Type.CHARACTER: "角色",
		Data.Type.VEHICLE: "载具",
		Data.Type.BUILDING: "建筑",
		Data.Type.WEAPON: "武器",
		Data.Type.ARMOR: "护甲",
		Data.Type.SKILL: "技能",
	}
	var type_name = type_map.get(card.type, "未知")
	text += "类型：			%s\n" % type_name
	
	var aff_map = {
		Data.Affiliation.ABYSSAL: "深渊",
		Data.Affiliation.MORTAL: "凡人",
		Data.Affiliation.CELESTIAL: "天界",
	}
	var affiliation_name = aff_map.get(card.affiliation, "未知")
	text += "属性：			%s\n" % affiliation_name
	
	if card.has("hp"):
		text += "生命值：			%d\n" % card["hp"]
	
	if card.has("damage"):
		text += "攻击力：			%d\n" % card["damage"]
	
	if card.has("attack_range"):
		text += "攻击范围：		%d\n" % card["attack_range"]
	
	if card.has("speed"):
		text += "速度：			%d\n" % card["speed"]
	
	if card.has("deployment_range"):
		text += "视野：			%d\n" % card["deployment_range"]
	
	if card.has("damage_reduction"):
		text += "减伤：			%d\n" % card["damage_reduction"]
	
	if card.has("text"):
		text += "%s" % card["text"]
	
	rich_text_label.text = text
	visible = true

func hide_hand_panel():
	visible = false
	
