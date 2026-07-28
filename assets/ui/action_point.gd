extends Control
class_name ActionPoint

@export var main_game: MainGame
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

func update_point(point:int):
	label.text = str(point)

func turn_changed_1to2():
	label.text = str(main_game.current_player1_action_point)
	label.visible = false
	animated_sprite_2d.animation = "turn_change_1to2"
	animated_sprite_2d.play()
	await animated_sprite_2d.animation_finished
	label.text = str(main_game.current_player2_action_point)
	label.visible = true
	
	
func turn_changed_2to1():
	label.text = str(main_game.current_player2_action_point)
	label.visible = false
	animated_sprite_2d.animation = "turn_change_2to1"
	animated_sprite_2d.play()
	await animated_sprite_2d.animation_finished
	label.text = str(main_game.current_player1_action_point)
	label.visible = true
	
func _init_turn(faction:Data.Faction):
	label.text = ""
	if faction == Data.Faction.PLAYER1:
		animated_sprite_2d.animation = "turn_player1"
		animated_sprite_2d.play()
	elif faction == Data.Faction.PLAYER2:
		animated_sprite_2d.animation = "turn_player2"
		animated_sprite_2d.play()
	var tween:Tween = create_tween()
	tween.tween_property(self,"visible",true,1).set_delay(0.3)
