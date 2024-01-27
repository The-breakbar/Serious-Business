extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if is_mouse_over():
		if event is InputEventMouseMotion:
			print("hover")
		elif event is InputEventMouseButton:
			print("click")
		
# Check if the mouse is over the card
func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var rect = get_global_rect()

	return rect.has_point(mouse_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
