class_name LevelSelectButton extends ButtonEnhanced

@export var level : PackedScene

func _on_pressed()-> void:
	assert(level != null)
	LevelSelect.request_level(level)
