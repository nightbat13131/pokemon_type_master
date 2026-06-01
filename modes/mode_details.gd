class_name ModeDetails extends Resource

@export var _all_choices : Array[Choice]
@export var _type_pairs :Array[TypePairs]
@export var shuffle_choices := false

@export var _min_characters := 3
@export var _max_characters := 10

@export var _min_size_password := 3
@export var _max_size_password := 7

func configure_spinbox_choice_count(spinbox: SpinBox) -> void:
	spinbox.set_min(_min_characters)
	spinbox.set_max(min(_max_characters, _all_choices.size()))
	spinbox.set_value_no_signal(_min_characters)

func configure_spinbox_password_length(spinbox: SpinBox) -> void:
	spinbox.set_min(_min_size_password)
	spinbox.set_max(_max_size_password)
	spinbox.set_value_no_signal(_min_size_password)

func get_choices(count: int) -> Array[Choice]:
	count = clampi(count, _min_characters, _max_characters)
	var this_round_choices := _all_choices.duplicate()
	if shuffle_choices:
		this_round_choices.shuffle()
	while this_round_choices.size() > count:
		this_round_choices.pop_back()
	return this_round_choices

func populate_guess_pairs(this_round_choices: Array[Choice]) -> void:
	var this_round_pairings : Array[TypePairs]
	for pair: TypePairs in _type_pairs:
		for choice: Choice in this_round_choices:
			if pair.is_included(choice):
				this_round_pairings.append(pair)
				break
	Guess.set_type_pairings(this_round_pairings)

func get_answer(choices : Array[Choice], width: int) -> Answer:
	width = clampi(width, _min_size_password, _max_size_password)
	assert(!choices.is_empty())
	var _answer := Answer.new()
	for i in range(width):
		_answer.add_choice(choices.pick_random())
	return _answer
