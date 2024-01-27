extends Control

@export var image = "troll"

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture_rect = get_node("image")
	var texture = load("res://assets/cards/" + image + "Full.png")
	texture_rect.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
