extends Control

var card_array: Array = [] # Array of Card (enum)
var player_cards: Array = []
var enemy_cards: Array = []

enum State {Start, PlayerTurn, EnemyTurn, End}
var gameState: State = State.Start;

enum Player {Player, Enemy}
enum Card {blank}
func getCardName(card: Card) -> String:
	return Card.keys()[card]

func getCardId(cardName: String) -> Card:
	return Card.values()[Card.keys().find(cardName)]

var player_card_container: Node

# Called when the node enters the scene tree for the first time.
func _ready():


	player_card_container = get_node("player/playerContainer")

	# Load all cards into array
	load_cards()
	# Draw 3 cards for each player
	for i in range(3):
		draw_card(Player.Player)
		draw_card(Player.Enemy)
	pass # Replace with function body.

func load_cards():
	# Load all cardnames into array
	for card in Card.values():
		card_array.push_back(card)
	print("card_array: ", card_array)


# Function to draw a random card from the array
func draw_card(player: Player):
	if card_array.size() > 0:
		var random_index = randi() % card_array.size()
		var drawn_card = card_array[random_index]
		
		if player == Player.Player:
			player_cards.push_back(drawn_card)
			add_card_to_hand_scene(drawn_card, Player.Player)
		else:
			enemy_cards.push_back(drawn_card)
		# You can add further logic here, e.g., for skipping a turn

		return drawn_card
	else:
		return null

func add_card_to_hand_scene(card: Card, player: Player):
	var card_scene = load("res://playerCard.tscn")
	print("getCardName(card): ", getCardName(card))
	card_scene.instantiate()
	card_scene.set_image(getCardName(card))
	player_card_container.add_child(card_scene)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
