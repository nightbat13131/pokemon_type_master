@tool
class_name CurrentChoice extends DisplayChoice

func _ready() -> void:
	super._ready()
	if !mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if !mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void: set_choice(null)

func drop_in_choice(resource: Choice) -> void: set_choice(resource)

func _on_mouse_entered() -> void: MouseHelper.mouse_in_display(self, true)

func _on_mouse_exited() -> void: MouseHelper.mouse_in_display(self, false)
