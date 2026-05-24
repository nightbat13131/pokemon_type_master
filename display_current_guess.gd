class_name DispalyCurrentGuess extends HBoxContainer

@export var bank : DisplayColorBank
@export var submit_button : Button

var _current_length

func _ready() -> void:
	assert(bank != null)
	bank.choice_request.connect(apply_choice)
	assert(submit_button != null)
	submit_button.pressed.connect(_on_submit)

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
		each.set_choice(null)

func apply_choice(choice: Choice, index: int = -1) -> void:
	var target : DisplayChoice
	if index < 0:
		target = get_next_empty()
	else:
		assert(index < get_child_count())
		target = get_child(int(index))
	if target:
		target.set_choice(choice)

func get_next_empty() -> DisplayChoice:
	for each in get_children():
		assert(each is DisplayChoice)
		if !each.has_choice():
			return each
	return null

func is_full() -> bool: return get_next_empty() == null

func _on_submit() -> void:
	if is_full():
		print("assadfasdf")
