extends ScrollContainer
## default scrolling to bottom ?

@onready var guess_holder: VBoxContainer = %GuessHolder

func _ready() -> void:
	guess_holder.child_entered_tree.connect(_force_down)

func _force_down(_node: Node) -> void:
	await get_tree().create_timer(.01).timeout
	__force_down()

func __force_down() -> void:
	set_v_scroll.call_deferred(get_v_scroll_bar().max_value) # doesn't work well
