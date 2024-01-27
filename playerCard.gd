extends Control

@export var image = "troll"

signal clicked(name)

func _ready():
	set_image(image)
	
func set_image(image_name: String):
	self.image = image_name
	var texture_rect = get_node("image")
	var texture = load("res://assets/cards/" + image_name + ".png")
	texture_rect.texture = texture

func _process(delta):
	pass

# if clicked on the card, emit the signal
func _input(event):
	if event is InputEventMouseButton:
		emit_signal("clicked", image)
