@tool
class_name HighLow_Choice extends Choice

var _value := 0 : set = set_value, get = get_value

func set_value(value: int) -> void: 
	_value = value
	set_text(str(_value))

func get_value() -> int: return _value
