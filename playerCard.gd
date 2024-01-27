extends Control

@export var image = "troll"

signal clicked(name)

func _ready():
	var texture_rect = get_node("image")
	var texture = load("res://assets/cards/" + image + ".png")
	texture_rect.texture = texture

func _process(delta):
	pass

# if clicked on the card, emit the signal
func _input(event):
	if event is InputEventMouseButton:
		emit_signal("clicked", image)
