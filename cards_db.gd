# cards_db.gd
extends Node

# dictionary of all the cards: String - Card_Class
var cards = {}

# Add a card to the dictionary
func add_card(card):
	cards[card._name] = card

# Get a card from the dictionary
func get_card(name):
	return cards[name]

class Card_Class:
	# has a name, a description, an amount of damage, and a list of effects
	var _name = ""
	var _description = ""
	var _damage = 0
	var _effects = []

	func _init(name, description, damage, effects):
		self._name = name
		self._description = description
		self._damage = damage
		self._effects = effects

enum EffectType { 
	# the different types of effects
	DAMAGE, HEAL, DRAW, DISCARD, SHUFFLE, REPEAT, END
}

func init_cards():
	add_card(Card_Class.new("troll", "Trollface Meme", 3, [EffectType.DAMAGE]))
	add_card(Card_Class.new("sitcom", "Friends Jingle", 4, [EffectType.DAMAGE]))
	# add_card(Card_Class.new("meme", "Doge Meme", 2, [EffectType.DAMAGE]))
	add_card(Card_Class.new("rick", "Rickroll", 6, [EffectType.DAMAGE]))
	add_card(Card_Class.new("crewmate", "Sussy Amongus", 5, [EffectType.DAMAGE]))
	add_card(Card_Class.new("cat", "Funny Cat", 3, [EffectType.DAMAGE]))
