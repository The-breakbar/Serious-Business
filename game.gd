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
var animated_bg: Node


# health
var MAX_PLAYER_HEALTH: int = 5
var player_health: int
var additional_player_damage_per_turn: int = 0

var MAX_ENEMY_HEALTH: int = 5
var enemy_health: int
var additional_enemy_damage_per_turn: int = 0

var damage_multiplier_next_round: int = 1

const Cards_Db = preload("res://cards_db.gd")
var cards_db = Cards_Db.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player_card_container = get_node("player/playerContainer")
	player_board_container = get_node("board/boardContainer/playerBoard")
	enemy_board_container = get_node("board/boardContainer/enemyBoard")
	cards_db.init_cards()

	board_damage = get_node("board")
	animated_bg = get_node("animatedBg")

	reset_game()
	# game_loop()

func reset_game():
	# Reset all variables
	card_array = []
	player_cards = []
	enemy_cards = []
	gameState = State.Attack
	player_first = true
	enemy_health = MAX_ENEMY_HEALTH
	player_health = MAX_PLAYER_HEALTH

	# reset board
	player_board_container.texture = load("res://assets/cards/blankPlayerFull.png")
	enemy_board_container.texture = load("res://assets/cards/blankEnemyFull.png")

	animated_bg.set_animation("0")

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
		
		await get_tree().create_timer(2).timeout

		handle_placed_cards()
		player_board_container.texture = load("res://assets/cards/blankPlayerFull.png")
		enemy_board_container.texture = load("res://assets/cards/blankEnemyFull.png")

		# change background animation if necessary
		var fight_progress = 1 - float(max(0, enemy_health)) / float(MAX_ENEMY_HEALTH)
		var animationIndex = "0"
		if fight_progress > 0.5:
			animationIndex = "1"
		if fight_progress > 0.75:
			animationIndex = "2"
		if fight_progress == 1:
			animationIndex = "3"
		animated_bg.set_animation(animationIndex)

		await get_tree().create_timer(2).timeout

		draw_card(Player.Player)
		board_damage.hide_damage()
		
		gameState = 0

		# is anybody dead?
		if player_health <= 0:
			print("player lost")
			reset_game()
		elif enemy_health <= 0:
			print("player won")
			reset_game()
	
	
	if !is_player_turn():
		play_enemy_turn()

	print("next turn gameState: ", get_state_name(gameState), " for player ", "player" if is_player_turn() else "enemy")

func handle_placed_cards():
	if placed_enemy_card == "" && placed_player_card == "":
		return
	
	# calculate difference between cards
	var player_card = cards_db.get_card(placed_player_card)
	print("player_card: ", player_card._name)
	var enemy_card = cards_db.get_card(placed_enemy_card)
	print("enemy_card: ", enemy_card._name)

	# calc damage difference
	var damage_difference = player_card._damage - enemy_card._damage
	print("damage_difference: ", damage_difference)

	damage_difference *= player_card._damage_multiplier_this_round
	damage_difference *= enemy_card._damage_multiplier_this_round
	damage_difference *= damage_multiplier_next_round

	# reset damage multiplier for next round
	damage_multiplier_next_round = 1
	damage_multiplier_next_round *= player_card._damage_multiplier_next_round
	damage_multiplier_next_round *= enemy_card._damage_multiplier_next_round

	# if damage difference is positive, apply damage to enemy
	if damage_difference > 0:
		print("enemy takes damage")
		enemy_health = enemy_health - damage_difference
	else:
		print("player takes damage")
		# plus because damage_difference is negative
		player_health = player_health + damage_difference

	# apply additional damage per turn
	enemy_health = enemy_health - additional_enemy_damage_per_turn
	if additional_enemy_damage_per_turn > 0:
		additional_enemy_damage_per_turn = additional_enemy_damage_per_turn - 1

	player_health = player_health - additional_player_damage_per_turn
	if additional_player_damage_per_turn > 0:
		additional_player_damage_per_turn = additional_player_damage_per_turn - 1
	
	if damage_difference < 0:
		board_damage.show_damage(damage_difference, 0)
	else:
		board_damage.show_damage(0, -1 * damage_difference)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
