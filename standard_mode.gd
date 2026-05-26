class_name StandardGame extends Node2D

@export var all_choices: Array[Choice]
@export var all_type_pairings : Array[TypePairs]
@onready var display_color_bank: DisplayColorBank = %DisplayColorBank
@onready var display_current_guess: DispalyCurrentGuess = %DisplayCurrentGuess
@onready var guess_history: GuessHistory = %"Guess History"
@onready var submit_button: Button = %SubmitButton
@onready var button_new_game: Button = %ButtonNewGame
@onready var color_bank_holder: VBoxContainer = %"Color Bank Holder"
@onready var current_guess_holder: VBoxContainer = %"Current Guess Holder"
@onready var spin_box_choices: SpinBox = %SpinBoxChoices
@onready var spin_box_length: SpinBox = %SpinBoxLength

var _answer: Answer

var this_round_choices: Array[Choice]
var this_round_pairings: Array[TypePairs]

func _ready() -> void:
	display_current_guess.submit_guess.connect(_on_guess_submited)
	button_new_game.pressed.connect(_on_newgame_request)
	spin_box_choices.set_max(all_choices.size())
	_on_newgame_request()

func game_start(number_of_choices := 4, password_width := 5) -> void:
	_generate_choices(number_of_choices)
	display_current_guess.set_guess_length(password_width)
	_generate_pairs()
	_generate_answer(this_round_choices, password_width)
	display_color_bank.set_bank_list(this_round_choices)
	guess_history.game_start()
	color_bank_holder.show()
	current_guess_holder.show()
	submit_button.disabled = false

func _generate_choices(count: int) -> void:
	this_round_choices = all_choices.duplicate()
	this_round_choices.shuffle()
	while this_round_choices.size() > count:
		this_round_choices.pop_back()

func _generate_pairs() -> void:
	#var holder := all_type_pairings.duplicate()
	this_round_pairings = []
	var count := 0
	for pair: TypePairs in all_type_pairings:
		for choice: Choice in this_round_choices:
			count += 1
			if pair.is_included(choice):
				this_round_pairings.append(pair)
				break
	Guess.set_type_pairings(this_round_pairings)

func _generate_answer(choices : Array[Choice], width: int) -> void:
	assert(!choices.is_empty())
	_answer = Answer.new()
	for i in range(width):
		_answer.add_choice(choices.pick_random())

func _on_guess_submited(guess: Guess) -> void:
	guess.check_answer(_answer)
	guess_history.add_guess(guess)
	if guess.is_correct():
		_solved()

func _solved() -> void: 
	color_bank_holder.hide()
	current_guess_holder.hide()
	submit_button.disabled = true

func _on_newgame_request() -> void: game_start(int(spin_box_choices.value), int(spin_box_length.value))
