@tool
class_name DisplayChoice extends Button

signal choice_pressed(choice: Choice)

const RADIUS = 30
const BANK_SIZE = Vector2(RADIUS * 2.2, RADIUS * 2.2)

@export var _choice: Choice: set = set_choice


func _ready() -> void:
	set_custom_minimum_size(BANK_SIZE)
	pressed.connect(_on_pressed)

func set_choice(resource: Choice):
	_choice = resource
	queue_redraw()

func _draw() -> void:
	var bg_color := Color.WEB_GRAY
	var tx_color := Color.BLUE
	var string := "_"
	if _choice:
		bg_color = _choice.background_color
		string = _choice.text
		tx_color = _choice.text_color
	draw_circle(BANK_SIZE *.5, RADIUS, bg_color)
	draw_string(get_theme_default_font(), BANK_SIZE *.5, string, HORIZONTAL_ALIGNMENT_CENTER,
	-1, 16, 
	tx_color)

func _on_pressed() -> void:
	if _choice:
		choice_pressed.emit(_choice)

func has_choice() -> bool: return _choice != null
