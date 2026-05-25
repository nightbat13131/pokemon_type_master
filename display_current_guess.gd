class_name DispalyCurrentGuess extends HBoxContainer

signal submit_guess(guess: Guess)

@export var bank : DisplayColorBank
@export var history: GuessHistory
@export var submit_button : Button

var _current_length

func _ready() -> void:
	assert(bank != null)
	bank.choice_request.connect(apply_choice)
	assert(submit_button != null)
	submit_button.pressed.connect(_on_submit)
	assert(history != null)
	history.choice_request.connect(apply_choice)
	child_entered_tree.connect(_on_child_entered_tree)
	for child in get_children():
		assert(child is DisplayChoice)
		_on_child_entered_tree(child)

func set_guess_length(length: int = 4) -> void:
	_current_length = length
	var delta = get_child_count() - _current_length 
	if delta == 0:
		return
	elif delta > 0: 
		for i in range(delta):
			get_child(i).queue_free()
	elif delta < 0 :
		for i in range(abs(delta)): 
			add_child(DisplayChoice.new())
	guess_start() 

func guess_start() -> void:
	for each: DisplayChoice in get_children():
		each.set_choice(null, true)

func apply_choice(choice: Choice, index: int = -1) -> void:
	var target : DisplayChoice
	if index < 0:
		target = get_next_empty()
	else:
		assert(index < get_child_count())
		target = get_child(index)
	if target:
		target.set_choice(choice, true)

func get_next_empty() -> DisplayChoice:
	for each in get_children():
		assert(each is DisplayChoice)
		if !each.has_choice():
			return each
	return null

func is_full() -> bool: return get_next_empty() == null

func _on_submit() -> void:
	if is_full():
		var _guess := Guess.new()
		for each in get_children():
			assert(each is DisplayChoice)
			if each is DisplayChoice:
				_guess.add_choice(each.pop_choice())
		submit_guess.emit(_guess)

func _on_child_entered_tree(node: Node) -> void:
	if node is DisplayChoice:
		assert(!node.choice_pressed.is_connected(_on_display_pressed))
		node.choice_pressed.connect(_on_display_pressed)

func _on_display_pressed(node: DisplayChoice, _index: int) -> void: node.clear_choice()
