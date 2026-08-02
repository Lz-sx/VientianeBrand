extends Node
class_name BoardInteraction
@onready var main_game: MainGame = $".."

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left") and main_game.map.is_click_on_map():
		if main_game.hand_card_be_selected == null:
			var target_pos = main_game.map.get_hovered_tile()
			if main_game.game_grid.grid_data[target_pos]["unit"] != null:

				main_game.hand_root.cancel_hand_card_selected()

				main_game.map_card_be_selected = main_game.game_grid.grid_data[target_pos]["unit"]
				print(main_game.map_card_be_selected)
				main_game.map_card_info.update_text(main_game.map_card_be_selected)
				main_game.map_card_info.visible = true
				main_game.map_card_operate.visible = false
				if main_game.my_faction == main_game.map_card_be_selected.Faction and\
				main_game.is_my_turn():
					main_game.map_card_operate.update_button(main_game.map_card_be_selected)
					main_game.map_card_operate.visible = true
	if event.is_action_pressed("mouse_right"):
		main_game.map_card_be_selected = null
		main_game.map_card_info.visible = false
		main_game.map_card_operate.visible = false
