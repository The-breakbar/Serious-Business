extends Control

var enemy_label : Label
var player_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_label = get_node("enemy/enemyDamage")
	player_label = get_node("player/hp/playerDamage")

	hide_damage()

	show_damage(-10)


func show_damage(damage):
	var text = "-" + str(abs(damage))

	if damage > 0:
		enemy_label.text = text
		enemy_label.visible = true
	else:
		player_label.text = text
		player_label.visible = true

	
func hide_damage():
	enemy_label.visible = false
	player_label.visible = false
