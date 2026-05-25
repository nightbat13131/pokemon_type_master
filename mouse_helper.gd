class_name MouseHelper extends Node2D

static var _instance : MouseHelper
static var _display_pressed : DisplayChoice
static var _mouse_over_display: DisplayChoice

func _ready() -> void:
	assert(_instance == null)
	_instance = self
	tree_exiting.connect(_on_tree_exiting)

func _on_tree_exiting() -> void: _instance = null

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	queue_redraw()

func _draw() -> void:
	if _display_pressed:
		if _display_pressed.has_choice():
			_display_pressed.remote_draw(self, Vector2.ZERO)

static func mouse_in_display(display: DisplayChoice, is_mouse_in: bool) -> void:
	if is_mouse_in:
		_mouse_over_display = display
	else:
		if _mouse_over_display == display:
			_mouse_over_display = null

static func mouse_event_from_display(event: InputEventMouse, display: DisplayChoice) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed(): # start of a press
			_display_pressed = display
			return # no other checks on this frame
	if _display_pressed != null:
		if !event.button_mask & MOUSE_BUTTON_MASK_LEFT: ## button is no longer being held
			if _display_pressed:
				try_drop_choice()

static func try_drop_choice() -> void:
	if _mouse_over_display and _display_pressed:
		_mouse_over_display.drop_in_choice(_display_pressed.get_choice())
	_display_pressed = null
