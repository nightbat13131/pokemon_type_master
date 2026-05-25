class_name StandardGame extends Node2D

@export var all_choices: Array[Choice]
@onready var display_color_bank: DisplayColorBank = %DisplayColorBank
@onready var display_current_guess: DispalyCurrentGuess = %DisplayCurrentGuess
@onready var guess_history: GuessHistory = %"Guess History"
@onready var submit_button: Button = %SubmitButton
@onready var button_new_game: Button = %ButtonNewGame
@onready var color_bank_holder: VBoxContainer = %"Color Bank Holder"
@onready var current_guess_holder: VBoxContainer = %"Current Guess Holder"

var _answer: Answer

var this_round_choices: Array[Choice]

func _ready() -> void:
	game_start()
	display_current_guess.submit_guess.connect(_on_guess_submited)
	button_new_game.pressed.connect(_on_newgame_request)

func game_start(number_of_choices := 4, password_width := 5) -> void:
	this_round_choices = all_choices.duplicate()
	this_round_choices.shuffle()
	display_current_guess.set_guess_length(password_width)
	while this_round_choices.size() > number_of_choices:
		this_round_choices.pop_back()
	generate_answer(this_round_choices, password_width)
	display_color_bank.set_bank_list(this_round_choices)
	guess_history.game_start()
	color_bank_holder.show()
	current_guess_holder.show()
	submit_button.disabled = false

func generate_answer(choices : Array[Choice], width: int) -> void:
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

func _on_newgame_request() -> void:
	game_start()
