# Player.gd
extends Node2D

var hand : Array = []

# Function to draw a random card from the array
func draw_card(card_array):
	if card_array.size() > 0:
		var random_index = randi() % card_array.size()
		var drawn_card = card_array[random_index].instance()
		
		hand.append(drawn_card)
		
		# You can add further logic here, e.g., for skipping a turn

		return drawn_card
	else:
		return null
