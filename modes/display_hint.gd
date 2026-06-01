extends CanvasLayer

var _is_showing := false : set = _set_is_showing

@export var _toggler :Button
@export var _shower :Control


func _ready() -> void:
	assert(_toggler != null)
	assert(_shower != null)
	_toggler.pressed.connect(_on_toggler_pressed)
	_set_is_showing(false)
	

func _on_toggler_pressed() -> void:
	_is_showing = !_is_showing

func _set_is_showing(new_: bool) -> void:
	_is_showing = new_ 
	_shower.set_visible(_is_showing)
