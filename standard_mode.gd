class_name StandardGame extends Node2D

@export var all_choices: Array[Choice]
@onready var display_color_bank: DisplayColorBank = %DisplayColorBank
@onready var display_current_guess: DispalyCurrentGuess = %DisplayCurrentGuess


var this_round_choices: Array[Choice]

func _ready() -> void:
	game_start()

func game_start(number_of_choices := 4) -> void:
	this_round_choices = all_choices.duplicate()
	this_round_choices.shuffle()
	display_current_guess.set_guess_length(number_of_choices)
	while this_round_choices.size() > number_of_choices:
		this_round_choices.pop_back()
	print(this_round_choices)
	display_color_bank.set_bank_list(this_round_choices)
	
