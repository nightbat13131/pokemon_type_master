@tool
extends Line2D

@export var _answer_side : DisplayChoice
@export var _attack_side : DisplayChoice
@export var _choice_pair : TypePairs

func _draw() -> void:
	if Engine.is_editor_hint():
		_engine_draw()
	else:
		Guess.draw_match_type(self, _get_result(), _get_mid_point())

func _engine_draw() -> void:
	draw_circle(_get_mid_point(), 15, Color.AZURE)

func _get_mid_point() -> Vector2:
	var _start = Vector2.ZERO
	var _end = Vector2.ZERO
	if get_point_count() > 0:
		_start = get_point_position(0)
		_end = get_point_position(get_point_count() -1)
	return (_end + _start) *.5

func _get_result() -> Guess.TypingMatch:
	if _choice_pair: 
		return _choice_pair.get_results(_attack_side.get_choice(), _answer_side.get_choice())
	return Guess.TypingMatch.NA
