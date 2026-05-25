class_name Answer extends Resource

var _choices : Array[Choice]

func add_choice(choice: Choice) -> void:
	_choices.append(choice)

func size() -> int: return _choices.size()

func get_copy_choices() -> Array[Choice] : return _choices.duplicate()

func get_choices() -> Array[Choice] : return _choices
