var card_array : Array = []
var player_a : Player = Player.new()
var player_b : Player = Player.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_cards()
	player_a.draw_card(card_array)
	player_b.draw_card(card_array)

# Function to load all cards into the card_array
func load_cards():
	var cards_folder = "res://path/to/cards/"  # Adjust the path to your cards
	var card_files = listdir(cards_folder)
	
	for file in card_files:
		if file.extension() == "tscn":
			var card_scene = preload(cards_folder + file)
			card_array.append(card_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
