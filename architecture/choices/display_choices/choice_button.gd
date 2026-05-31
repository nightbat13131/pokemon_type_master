@tool
class_name DisplayChoice extends ButtonEnhanced
## click and drag helper https://godot.snoeyz.com/drag-and-drop/

signal choice_pressed(display: DisplayChoice, index: int)

const COMMON_SIZE = Vector2(Choice.DRAW_RADIUS * 2.2, Choice.DRAW_RADIUS * 2.2)
const GUESS_SIZE = COMMON_SIZE * .75
const PAST_SIZE =  COMMON_SIZE * .75

@export var event_debug := false

@export var _choice: Choice : set = set_choice
var _index := -1 : set = set_index
var _result_type := Guess.TypingMatch.INVALID

func _ready() -> void:
	super._ready()
	_update_size()
	gui_input.connect(_on_gui_input)

func _update_size() -> void: set_custom_minimum_size(COMMON_SIZE)

func set_choice(resource: Choice) -> void:
	_choice = resource
	queue_redraw()

func set_result_type(result: Guess.TypingMatch ) -> void:
	_result_type = result
	queue_redraw()

func has_choice() -> bool: return _choice != null

func set_index(index: int ) -> void: _index = index

func _draw() -> void: 
	remote_draw(self,  size * .5)
	Guess.draw_match_type(self, _result_type)

func remote_draw(node: CanvasItem, center: Vector2) -> void:
	if _choice:
		_choice.remote_draw(node, center)
	else:
		Choice.remote_void_draw(node, center)

func _on_pressed() -> void:
	if _choice:
		choice_pressed.emit(self, _index)

func pop_choice() -> Choice:
	var a : Choice = _choice
	set_choice(null)
	return a

func get_choice() -> Choice: return _choice

func _on_gui_input(event: InputEvent) -> void:
	if event_debug: 
		print(event)
	if event is InputEventMouse: # or event is InputEventMouseMotion:
		MouseHelper.mouse_event_from_display(event, self)

func is_active() -> bool: return !disabled

func deactivate() -> void: set_disabled(true)

func activate() -> void: set_disabled(false)
