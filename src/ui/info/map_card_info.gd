extends Control
class_name MapCardInfo
@onready var building: Button = $HBoxContainer/Building
@onready var vehicle: Button = $HBoxContainer/Vehicle
@onready var character: Button = $HBoxContainer/Character
@onready var weapon: Button = $HBoxContainer/Weapon
@onready var armor: Button = $HBoxContainer/Armor
@onready var rich_text_label: RichTextLabel = $RichTextLabel

var building_text:String
var vehicle_text:String
var character_text:String
var weapon_text:String
var armor_text:String

func update_text(map_card_be_selected:CardBaseOnmap):
	building_text = ""
	vehicle_text = ""
	character_text = ""
	weapon_text = ""
	armor_text = ""
	rich_text_label.text = ""
	building.visible = false
	vehicle.visible = false
	character.visible = false
	weapon.visible = false
	armor.visible = false
	
	_collect_card_data(map_card_be_selected)

func _collect_card_data(card:CardBaseOnmap):
	if card == null:
		return
	if not Data.card_data.has(card.id):
		return
	
	var data = Data.card_data[card.id]
	var name = data["name"]
	
	match card.Type:
		Data.Type.BUILDING:
			building.visible = true
			building_text = "名称：			%s\n" % name
			building_text += "生命值：			%d\n" % card.hp
			building_text += "攻击力：			%d\n" % card.damage
			if data.has("text"):
				building_text += "%s" % data["text"]
			
			var garrison = card.get_node_or_null("Garrison")
			if garrison != null:
				for child in garrison.get_children():
					_collect_card_data(child)
			rich_text_label.text = building_text
		Data.Type.VEHICLE:
			vehicle.visible = true
			vehicle_text = "名称：			%s\n" % name
			vehicle_text += "生命值：			%d\n" % card.hp
			vehicle_text += "攻击力：			%d\n" % card.damage
			if data.has("text"):
				vehicle_text += "%s" % data["text"]
			
			var passenger = card.get_node_or_null("Passenger")
			if passenger != null:
				for child in passenger.get_children():
					_collect_card_data(child)
			if rich_text_label.text == "":
				rich_text_label.text = vehicle_text
		Data.Type.CHARACTER:
			character.visible = true
			character_text = "名称：			%s\n" % name
			character_text += "生命值：			%d\n" % card.hp
			character_text += "攻击力：			%d\n" % card.damage
			if data.has("text"):
				character_text += "%s" % data["text"]
			if rich_text_label.text == "":
				rich_text_label.text = character_text
			var weapon_node = card.get_node_or_null("Weapon")
			if weapon_node != null:
				for child in weapon_node.get_children():
					_collect_card_data(child)
			
			var armor_node = card.get_node_or_null("Armor")
			if armor_node != null:
				for child in armor_node.get_children():
					_collect_card_data(child)
		
		Data.Type.WEAPON:
			weapon.visible = true
			weapon_text = "名称：			%s\n" % name
			var weapon_card = card as WeaponCardBase
			weapon_text += "攻击力增幅：		%d\n" % weapon_card.damage_bonus
			weapon_text += "攻击范围增幅：	%d\n" % weapon_card.attack_range_bonus
			if data.has("text"):
				weapon_text += "%s" % data["text"]
		
		Data.Type.ARMOR:
			armor.visible = true
			armor_text = "名称：			%s\n" % name
			var armor_card = card as ArmorCardBase
			armor_text += "伤害减免：		%d\n" % armor_card.damage_reduction
			if data.has("text"):
				armor_text += "%s" % data["text"]


func _on_building_pressed() -> void:
	rich_text_label.text = building_text


func _on_vehicle_pressed() -> void:
	rich_text_label.text = vehicle_text


func _on_character_pressed() -> void:
	rich_text_label.text = character_text


func _on_weapon_pressed() -> void:
	rich_text_label.text = weapon_text


func _on_armor_pressed() -> void:
	rich_text_label.text = armor_text
