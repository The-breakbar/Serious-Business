extends Control

@export var image = "blank"

var highlight = false
var popup = false
var game_node : Node
var popup_node : Node

signal clicked(name)

func _ready():
	game_node = get_tree().get_root().get_node("game")
	popup_node = get_node("popup")
	popup_node.visible = false
	popup_node.texture = null
	set_image(image)
	
func set_image(image_name: String):
	self.image = image_name
	var texture_rect = get_node("image")
	var texture = load("res://assets/cards/" + image_name + ".png")
	texture_rect.texture = texture

	var popup_rect = get_node("popup")
	var popup_texture = load("res://assets/cards/" + image_name + "Popup.png")
	popup_rect.texture = popup_texture
	
func get_image():
	return image

func _process(delta):
	pass

# if clicked on the card, emit the signal
func _input(event):
	if is_mouse_over():
		if event is InputEventMouseButton:
			emit_signal("clicked", image)

		# show hover effect
		if !highlight && game_node.is_player_turn():
			highlight = true
			get_node("hover").visible = true

		if !popup && game_node.is_player_turn():
			popup = true
			popup_node.visible = true

	else:
		if highlight:
			highlight = false
			get_node("hover").visible = false

		if popup:
			popup = false
			popup_node.visible = false

func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var rect = get_global_rect()

	return rect.has_point(mouse_pos)
