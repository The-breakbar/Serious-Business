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
enum Card {troll, sitcom, crewmate, rick, cat}
func getCardName(card: Card) -> String:
	return Card.keys()[card]

func getCardId(cardName: String) -> Card:
	return Card.values()[Card.keys().find(cardName)]

var player_card_container: Node
var player_board_container: Node
var placed_player_card: String
var enemy_board_container: Node
var placed_enemy_card: String

var board_damage: Node

# health
var player_health: int = 100
var enemy_health: int = 100

const Cards_Db = preload("res://cards_db.gd")
var cards_db = Cards_Db.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player_card_container = get_node("player/playerContainer")
	player_board_container = get_node("board/boardContainer/playerBoard")
	enemy_board_container = get_node("board/boardContainer/enemyBoard")
	cards_db.init_cards()

	board_damage = get_node("board")

	reset_game()
	# game_loop()

func reset_game():
	# Reset all variables
	card_array = []
	player_cards = []
	enemy_cards = []
	gameState = State.Attack
	player_first = true

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
			add_card_to_hand_scene(drawn_card)
		else:
			print("enemy cards: ", enemy_cards)
			enemy_cards.push_back(drawn_card)
			print("enemy draws card: ", getCardName(drawn_card))
			print("enemy cards: ", enemy_cards)
		# You can add further logic here, e.g., for skipping a turn

		return drawn_card
	else:
		return null

func add_card_to_hand_scene(card: Card):
	var card_scene = load("res://playerCard.tscn")
	print("getCardName(card): ", getCardName(card))
	
	var card_instance = card_scene.instantiate()
	card_instance.set_image(getCardName(card))
	card_instance.clicked.connect(card_selected)

	player_card_container.add_child(card_instance)

func is_player_turn() -> bool:
	return (gameState == State.Attack && player_first) || (gameState == State.Defense && !player_first)

func card_selected(card_name: String):
	# if (gameState != State.PlayerAttack && gameState != State.PlayerDefend):
	if !is_player_turn():
		return
	
	# gameState = State.EnemyDefend if player_first else State.TurnEnd
	player_board_container.texture = load("res://assets/cards/" + card_name + ".png")
	placed_player_card = card_name

	# remove this card from player_cards
	var card_id = getCardId(card_name)
	player_cards.erase(card_id)

	# remove this card from player_card_container
	for child in player_card_container.get_children():
		if child.get_image() == card_name:
			child.queue_free()
			break

	next_turn()

func play_enemy_turn():
	print("ENEMY TURN TIMEOUT START")

	# wait 3 second
	await get_tree().create_timer(3).timeout

	print("ENEMY TURN TIMEOUT END")

	# select random enemy card
	var random_index = randi() % enemy_cards.size()
	var card_id = enemy_cards[random_index]
	var card_name = getCardName(card_id)

	# remove this card from enemy_cards
	enemy_cards.erase(card_id)

	print("remove card from enemy hand: ", card_name)

	# add card to enemy board
	enemy_board_container.texture = load("res://assets/cards/" + card_name + ".png")
	placed_enemy_card = card_name
	print("enemy plays card: ", card_name)
	draw_card(Player.Enemy)
	next_turn()

func next_turn():
	gameState = gameState + 1

	if gameState == State.TurnEnd:
		print("process turn end")
		player_first = !player_first
		var damage = handle_placed_cards()
		
		await get_tree().create_timer(2).timeout

		player_board_container.texture = load("res://assets/cards/blankPlayerFull.png")
		enemy_board_container.texture = load("res://assets/cards/blankEnemyFull.png")
		board_damage.show_damage(damage)

		await get_tree().create_timer(2).timeout

		draw_card(Player.Player)
		board_damage.hide_damage()

		gameState = 0
	
	if !is_player_turn():
		play_enemy_turn()

	print("next turn gameState: ", get_state_name(gameState), " for player ", "player" if is_player_turn() else "enemy")

func handle_placed_cards():
	if placed_enemy_card == "" && placed_player_card == "":
		return
	
	# calculate difference between cards
	var player_card = cards_db.get_card(placed_player_card)
	var enemy_card = cards_db.get_card(placed_enemy_card)

	# calc damage difference
	var damage_difference = player_card._damage - enemy_card._damage
	print("damage_difference: ", damage_difference)

	# if damage difference is positive, apply damage to enemy
	if damage_difference > 0:
		print("enemy takes damage")
		enemy_health = enemy_health - damage_difference
	else:
		print("player takes damage")
		# plus because damage_difference is negative
		player_health = player_health + damage_difference

	return damage_difference


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
