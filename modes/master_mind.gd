class_name MasterMind extends Node2D

@export var _choice_details : ModeDetails
#@export var all_choices: Array[Choice]
#@export var shuffle_choices := false
#@export var all_type_pairings : Array[TypePairs]
@onready var display_current_guess: DispalyCurrentGuess = %DisplayCurrentGuess
@onready var guess_history: GuessHistory = %"Guess History"
@onready var submit_button: Button = %SubmitButton
@onready var button_new_game: Button = %ButtonNewGame
@onready var bank_holder: BankHolder = %"BankHolder"
@onready var current_guess_holder: VBoxContainer = %"Current Guess Holder"
@onready var spin_box_choices: SpinBox = %SpinBoxChoices
@onready var spin_box_length: SpinBox = %SpinBoxLength

var _answer: Answer

var this_round_choices: Array[Choice]
var this_round_pairings: Array[TypePairs]

func _ready() -> void:
	assert(_choice_details != null)
	_choice_details.configure_spinbox_choice_count(spin_box_choices)
	_choice_details.configure_spinbox_password_length(spin_box_length)
	display_current_guess.submit_guess.connect(_on_guess_submited)
	button_new_game.pressed.connect(_on_newgame_request)
	_on_newgame_request()

func game_start(number_of_choices := 4, password_width := 5) -> void:
	this_round_choices = _choice_details.get_choices(number_of_choices)
	_choice_details.populate_guess_pairs(this_round_choices)
	_answer = _choice_details.get_answer(this_round_choices, password_width)
	display_current_guess.set_answer(_answer)
	bank_holder.activate()
	bank_holder.set_bank_list(this_round_choices)
	guess_history.game_start()
	current_guess_holder.show()
	submit_button.disabled = false

func _on_guess_submited(guess: Guess) -> void:
	guess_history.add_guess(guess)
	if guess.is_correct():
		_solved()

func _solved() -> void: 
	print ("You Win")
	bank_holder.deactivate()
	current_guess_holder.hide()
	submit_button.disabled = true

func _on_newgame_request() -> void: game_start(int(spin_box_choices.value), int(spin_box_length.value))
