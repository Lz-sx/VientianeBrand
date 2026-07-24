extends Control
class_name  MapCardOperate
@onready var building: HBoxContainer = $VBoxContainer/Building
@onready var vehicle: HBoxContainer = $VBoxContainer/Vehicle
@onready var character: HBoxContainer = $VBoxContainer/Character
@onready var weapon: HBoxContainer = $VBoxContainer/Weapon
@onready var armor: HBoxContainer = $VBoxContainer/Armor
const default_name_size = 3

func update_button(map_card_be_selected:CardBaseOnmap):
	building.visible = false
	vehicle.visible = false
	character.visible = false
	weapon.visible = false
	armor.visible = false
	
	show_button(map_card_be_selected)

func show_button(card:CardBaseOnmap):
	if not Data.card_data.has(card.id):
		return
	
	var data = Data.card_data[card.id]
	var name = data["name"]
	var none_space = default_name_size - name.length()
	if none_space > 0:
		for i in range(none_space*2):
			name += " "
	
	match card.Type:
		Data.Type.BUILDING:
			building.visible = true
			building.get_node("Name").text = name
			building.get_node("Attack").visible = true
			building.get_node("Skill").visible = true
			var garrison = card.get_node_or_null("Garrison")
			if garrison != null:
				for child in garrison.get_children():
					show_button(child)
		Data.Type.VEHICLE:
			vehicle.visible = true
			vehicle.get_node("Name").text = name
			vehicle.get_node("Attack").visible = true
			vehicle.get_node("Move").visible = true
			vehicle.get_node("Skill").visible = true
			
			var passenger = card.get_node_or_null("Passenger")
			if passenger != null:
				for child in passenger.get_children():
					show_button(child)
		Data.Type.CHARACTER:
			character.visible = true
			character.get_node("Name").text = name
			character.get_node("Attack").visible = true
			character.get_node("Move").visible = true
			character.get_node("Skill").visible = true
			var weapon_node = card.get_node_or_null("Weapon")
			if weapon_node != null:
				for child in weapon_node.get_children():
					show_button(child)
			
			var armor_node = card.get_node_or_null("Armor")
			if armor_node != null:
				for child in armor_node.get_children():
					show_button(child)
		
		Data.Type.WEAPON:
			weapon.visible = true
			weapon.get_node("Name").text = name
			weapon.get_node("Skill").visible = true
		
		Data.Type.ARMOR:
			armor.visible = true
			armor.get_node("Name").text = name
			armor.get_node("Skill").visible = true

func _on_building_attack_pressed():
	Events.building_attack.emit()

func _on_building_skill_pressed():
	Events.building_skill.emit()

func _on_vehicle_attack_pressed():
	Events.vehicle_attack.emit()
	
func _on_vehicle_move_pressed():
	Events.vehicle_move.emit()
	
func _on_vehicle_skill_pressed():
	Events.vehicle_skill.emit()
	
func _on_character_attack_pressed():
	Events.character_attack.emit()
	
func _on_character_move_pressed():
	Events.character_move.emit()
	
func _on_character_skill_pressed():
	Events.character_skill.emit()

func _on_weapon_skill_pressed():
	Events.weapon_skill.emit()
	
func _on_armor_skill_pressed():
	Events.armor_skill.emit()
