class_name DisplayColorBank extends Container

signal choice_request(choice: Choice)

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	for child in get_children():
		_on_child_entered_tree(child)

func set_bank_list(list: Array[Choice]) -> void:
	var display: DisplayChoice
	var choice: Choice
	for index in range(max(get_child_count(), list.size())):
		choice = list.get(index)
		if get_child_count() <= index:
			add_child(DisplayChoice.new())
		display = get_child(index)
			
		if choice:
			display.set_choice(choice)
		else:
			display.hide()
		_update_choice(index, list[index])

func _update_choice(index: int, choice: Choice) -> void:
	var current_choice : DisplayChoice = get_child(index)
	assert(current_choice != null)
	current_choice.set_choice(choice)

func _on_child_entered_tree(node: Node) -> void:
	if node is DisplayChoice:
		assert(!node.choice_pressed.is_connected(_on_display_pressed))
		node.choice_pressed.connect(_on_display_pressed)

func _on_display_pressed(display: DisplayChoice, _index: int) -> void: 
	choice_request.emit(display.get_choice())
