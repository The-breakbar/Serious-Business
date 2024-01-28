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
	var _continuous_damage = 0
	var _damage_multiplier_next_round = 1
	var _damage_multiplier_this_round = 1
	var _heal_amount = 0
	var _effects = []

	func _init(name, description, damage, effects, continuous_damage = 0, damage_multiplier_next_round = 1, damage_multiplier_this_round = 1, heal_amount = 0):
		self._name = name
		self._description = description
		self._damage = damage
		self._effects = effects
		self._continuous_damage = continuous_damage
		self._damage_multiplier_next_round = damage_multiplier_next_round
		self._damage_multiplier_this_round = damage_multiplier_this_round
		self._heal_amount = heal_amount

enum EffectType { 
	# the different types of effects
	DAMAGE, HEAL, DRAW, DISCARD, SHUFFLE, REPEAT, END, STUN
}

func init_cards():
	add_card(Card_Class.new("troll", "Trollface Meme", 3, [EffectType.DAMAGE], 0, 2, 1, 0))
	add_card(Card_Class.new("sitcom", "Friends Jingle", 2, [EffectType.DAMAGE], 1, 1, 1, 0))
	# add_card(Card_Class.new("meme", "Doge Meme", 2, [EffectType.DAMAGE]))
	add_card(Card_Class.new("rick", "Rickroll", 6, [EffectType.DAMAGE, EffectType.STUN]))
	add_card(Card_Class.new("crewmate", "Sussy Amongus", 4, [EffectType.DAMAGE], 0, 1, 1, 0))
	add_card(Card_Class.new("cat", "Funny Cat", 2, [EffectType.DAMAGE], 0, 1, 1, 3))
