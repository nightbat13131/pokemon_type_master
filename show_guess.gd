class_name DisplayGuess extends HBoxContainer

signal choice_request(choice: Choice, index: int)

var _guess : Guess

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)

func set_guess(guess: Guess) -> void:
	_guess = guess
	_setup_guess.call_deferred()

func _setup_guess() -> void:
	var display_choice : DisplayChoice
	var count := 0
	for choice in _guess.get_choices():
		display_choice = DisplayChoice.new()
		display_choice.set_choice(choice)
		display_choice.set_index(count)
		count += 1
		add_child(display_choice)
	var show_results = DisplayResults.new()
	add_child(show_results)
	show_results.set_results(_guess)
	

func _on_child_entered_tree(node: Node) -> void:
	if node is DisplayChoice:
		assert(!node.choice_pressed.is_connected(_on_display_pressed))
		node.choice_pressed.connect(_on_display_pressed)

func _on_display_pressed(display: DisplayChoice, index: int) -> void: 
	choice_request.emit(display.get_choice(), index)
