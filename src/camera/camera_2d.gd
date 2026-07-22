extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				if(zoom.x<=4 and zoom.y<=4):
					self.zoom.x+=0.25
					self.zoom.y+=0.25
			MOUSE_BUTTON_WHEEL_DOWN:
				if(zoom.x>=1.6 and zoom.y>=1.6):
					self.zoom.x-=0.25
					self.zoom.y-=0.25
