class_name DisplayResults extends Control

var _results: Guess

func set_results(resutls: Guess) -> void:
	_results = resutls
	set_custom_minimum_size(_results.get_display_size())
	queue_redraw()

func _draw() -> void:
	if _results:
		_results.remote_draw_match_results(self)
