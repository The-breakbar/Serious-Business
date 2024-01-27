extends Control

var card_array: Array = [] # Array of Card (enum)
var player_cards: Array = []
var enemy_cards: Array = []

enum State {Attack, Defense, TurnEnd}
func get_state_name(state: State) -> String:
	return State.keys()[state]
var player_first: bool
var gameState: State

enum Player {Player, Enemy}
enum Card {troll}
func getCardName(card: Card) -> String:
	return Card.keys()[card]

func getCardId(cardName: String) -> Card:
	return Card.values()[Card.keys().find(cardName)]

var player_card_container: Node
var player_board_container: Node
var enemy_board_container: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	player_card_container = get_node("player/playerContainer")
	player_board_container = get_node("board/boardContainer/playerBoard")
	enemy_board_container = get_node("board/boardContainer/enemyBoard")

	reset_game()

func reset_game():
	# Reset all variables
	card_array = []
	player_cards = []
	enemy_cards = []
	gameState = State.TurnEnd
	player_first = false

	# reset board
	player_board_container.texture = load("res://assets/cards/blankPlayerFull.png")
	enemy_board_container.texture = load("res://assets/cards/blankEnemyFull.png")

	# Remove all children from player_card_container
	for child in player_card_container.get_children():
		child.queue_free()

	# Load all cards into array
	load_cards()
	# Draw 3 cards for each player
	for i in range(3):
		draw_card(Player.Player)
		draw_card(Player.Enemy)

	next_turn()

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
	
	var card_instance = card_scene.instantiate()
	card_instance.set_image(getCardName(card))
	card_instance.clicked.connect(card_selected)

	player_card_container.add_child(card_instance)

func player_turn() -> bool:
	return (gameState == State.Attack && player_first) || (gameState == State.Defense && !player_first)

func card_selected(name: String):
	# if (gameState != State.PlayerAttack && gameState != State.PlayerDefend):
	if !player_turn():
		return
	
	# gameState = State.EnemyDefend if player_first else State.TurnEnd
	player_board_container.texture = load("res://assets/cards/" + name + ".png")

	# remove this card from player_cards
	var card_id = getCardId(name)
	player_cards.erase(card_id)

	# remove this card from player_card_container
	for child in player_card_container.get_children():
		if child.get_image() == name:
			child.queue_free()
			break

	next_turn()

func play_enemy_turn():
	# wait 3 second
	await get_tree().create_timer(3).timeout

	# select random enemy card
	var random_index = randi() % enemy_cards.size()
	var card_id = enemy_cards[random_index]
	var card_name = getCardName(card_id)

	# remove this card from enemy_cards
	enemy_cards.erase(card_id)

	# add card to enemy board
	enemy_board_container.texture = load("res://assets/cards/" + card_name + ".png")

func next_turn():
	# if (gameState == State.TurnEnd):
	# 	gameState = State.PlayerAttack if player_first else State.EnemyAttack
	# 	player_first = !player_first
	# elif (gameState == State.EnemyAttack || gameState == State.EnemyDefend):
	# 	play_enemy_turn()
	# 	gameState = State.PlayerDefend if !player_first else State.TurnEnd

	if gameState == State.TurnEnd:
		player_first = !player_first
		gameState = 0
	else:
		gameState = gameState + 1

	print("next turn gameState: ", get_state_name(gameState), " for player ", "player" if player_turn() else "enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
