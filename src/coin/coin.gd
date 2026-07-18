extends Control
class_name Coin

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func show_flip_coin():
	animated_sprite_2d.animation = "flip"
	animated_sprite_2d.play()

func show_red_side():
	animated_sprite_2d.animation = "red_side"
	animated_sprite_2d.play()
	
func show_blue_side():
	animated_sprite_2d.animation = "blue_side"
	animated_sprite_2d.play()

func fade_out():
	animation_player.play("fade_out")
	await  animation_player.animation_finished
