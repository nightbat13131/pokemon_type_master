class_name HighLowMode extends ModeDetails

func configure_spinbox_choice_count(spinbox: SpinBox) -> void:
	super.configure_spinbox_choice_count(spinbox)
	spinbox.set_max(_max_characters)

func get_choices(count: int) -> Array[Choice]:
	count = clampi(count, _min_characters, _max_characters)
	if count != _all_choices.size():
		_populate_choices(count)
	return super.get_choices(count)

func _populate_choices(count: int) -> void:
	if count == _all_choices.size():
		return
	while _all_choices.size() < count:
		_all_choices.append(HighLow_Choice.new())
	while _all_choices.size() > count:
		_all_choices.pop_back()
	var _color : Color
	var _current_choice : HighLow_Choice
	for index in range(count):
		_current_choice = _all_choices[index]
		_color = Color.from_hsv(index/float(count), 1.0, 1.0)
		_current_choice.set_value(index+1)
		_current_choice.set_bg_color(_color)
		_current_choice.set_text_color(Color.BLACK)
