class_name GuessHistory extends VBoxContainer

signal choice_request(choice: Choice, index: int)

@onready var guess_holder: VBoxContainer = %GuessHolder

func add_guess(guess: Guess) -> void:
	var display_guess := DisplayGuess.new()
	display_guess.set_guess(guess)
	display_guess.choice_request.connect(_on_choice_pressed)
	guess_holder.add_child(display_guess)
	#guess_holder.move_child(display_guess, 0)

func _on_choice_pressed(choice: Choice, index: int) -> void:
	choice_request.emit(choice, index)

func game_start() -> void:
	for each in guess_holder.get_children():
		each.queue_free()
