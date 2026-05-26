@tool
class_name DisplayChoice extends Button
## click and drag helper https://godot.snoeyz.com/drag-and-drop/

signal choice_pressed(display: DisplayChoice, index: int)

const SIZE = Vector2(Choice.DRAW_RADIUS * 2.2, Choice.DRAW_RADIUS * 2.2)

@export var event_debug := false

var _is_current_guess := false : set = set_is_current_guess

@export var _choice: Choice #: set = set_choice
var _index := -1 : set = set_index
var _result_type := Guess.TypingMatch.INVALID

func _ready() -> void:
	set_custom_minimum_size(SIZE)
	pressed.connect(_on_pressed)
	gui_input.connect(_on_gui_input)

func set_is_current_guess(is_current_guess: bool) -> void:
	if _is_current_guess == is_current_guess: 
		return 
	_is_current_guess = is_current_guess
	if _is_current_guess:
		if !mouse_entered.is_connected(_on_mouse_entered):
			mouse_entered.connect(_on_mouse_entered)
		if !mouse_exited.is_connected(_on_mouse_exited):
			mouse_exited.connect(_on_mouse_exited)
	else: 
		if mouse_entered.is_connected(_on_mouse_entered):
			mouse_entered.disconnect(_on_mouse_entered)
		if mouse_exited.is_connected(_on_mouse_exited):
			mouse_exited.disconnect(_on_mouse_exited)

func set_choice(resource: Choice, is_current_guess:= false):
	_choice = resource
	set_is_current_guess (is_current_guess)
		
	queue_redraw()

func set_result_type(result: Guess.TypingMatch ) -> void:
	_result_type = result
	queue_redraw()

func drop_in_choice(resource: Choice) -> void:
	if is_guess_choice():
		set_choice(resource, _is_current_guess)

func clear_choice() -> void:
	set_choice(null, _is_current_guess)

func is_guess_choice() -> bool: return _is_current_guess

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
	#remote_draw(self)

func _on_pressed() -> void:
	if _choice:
		choice_pressed.emit(self, _index)

func pop_choice() -> Choice:
	var a : Choice = _choice
	set_choice(null, _is_current_guess)
	return a

func get_choice() -> Choice: return _choice

func _on_mouse_entered() -> void:
	assert(_is_current_guess)
	MouseHelper.mouse_in_display(self, true)

func _on_mouse_exited() -> void: 
	assert(_is_current_guess)
	MouseHelper.mouse_in_display(self, false)

func _on_gui_input(event: InputEvent) -> void:
	if event_debug: 
		print(event)
	if event is InputEventMouse: # or event is InputEventMouseMotion:
		MouseHelper.mouse_event_from_display(event, self,)
