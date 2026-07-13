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
				if(zoom.x<=2.5 && zoom.y<=2.5):
					self.zoom.x+=0.2
					self.zoom.y+=0.2
			MOUSE_BUTTON_WHEEL_DOWN:
				if(zoom.x>=1.5 && zoom.y>=1.5):
					self.zoom.x-=0.2
					self.zoom.y-=0.2
