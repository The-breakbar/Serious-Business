extends Control

var enemy_label : Label
var player_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_label = get_node("../enemy/enemyDamage")
	player_label = get_node("../player/hp/playerDamage")

	hide_damage()


func show_damage(playerDamage, enemyDamage):
	if playerDamage != 0:
		var prefix = "+" if playerDamage > 0 else ""
		player_label.text = prefix + str(playerDamage)

		if playerDamage > 0:
			player_label.set("custom_colors/font_color", Color(0, 1, 0))
		else:
			player_label.set("custom_colors/font_color", Color(1, 0, 0))

		player_label.visible = true

	if (enemyDamage != 0) || (enemyDamage == 0 && playerDamage == 0):
		var prefix = "+" if enemyDamage > 0 else ("-" if enemyDamage == 0 else "")
		enemy_label.text = prefix + str(enemyDamage)

		if enemyDamage > 0:
			enemy_label.set("custom_colors/font_color", Color(0, 1, 0))
		else:
			enemy_label.set("custom_colors/font_color", Color(1, 0, 0))

		enemy_label.visible = true

	
func hide_damage():
	enemy_label.visible = false
	player_label.visible = false
