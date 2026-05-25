class_name Guess extends Answer

const UNIT = DisplayChoice.SIZE.x *.5
const RESULT_RADIUS = UNIT *.45

enum MatchType {
	NO_MATCH = 0,
	PERFECT = 1, 
	WRONG_POS = 2, 
}

var _results : Array[MatchType]

func check_answer(answer: Answer) -> void:
	assert(answer.size() == self.size())
	var _answer : Array[Choice] = answer.get_copy_choices()
	var _guess : Array[Choice] = self.get_copy_choices()
	for index in range(size()):
		if _answer[index] == _guess[index]:
			_results.append(MatchType.PERFECT)
			_answer[index] = null
			_guess[index] = null
	for remaining_guess in _guess:
		if remaining_guess != null:
			if _answer.has(remaining_guess):
				_results.append(MatchType.WRONG_POS)
				_answer.erase(remaining_guess)
	for remaining_answer in _answer:
		if remaining_answer != null:
			_results.append(MatchType.NO_MATCH)
	print(_results)

func is_correct() -> bool:
	assert(!_results.is_empty())
	for result in _results:
		if result != MatchType.PERFECT:
			return false
	return true

func get_display_size() -> Vector2:
	var out := DisplayChoice.SIZE
	if size() < 5:
		return out
	out.x = UNIT * ceil(size() * .5)
	return out

func remote_draw(node: CanvasItem) -> void:
	var _size := get_display_size()
	node.draw_polygon(
		[Vector2.ZERO, Vector2(_size.x, 0), _size, Vector2(0, _size.y) ], 
		[Color.AQUAMARINE]
	)
	var rows := 2
	var cols : int = ceil(size()*.5)
	var index := 0
	var center := Vector2.ZERO
	for row in range(rows):
		center.y = DisplayChoice.SIZE.y * .25
		center.y += ( DisplayChoice.SIZE.y * .5 ) * row
		center.x = DisplayChoice.SIZE.x * -.25 
		for col in range(cols):
			if index >= size():
				break
			center.x += DisplayChoice.SIZE.y * .5
			match _results[index]:
				MatchType.NO_MATCH:
					_draw_no_match(node, center)
				MatchType.PERFECT:
					_draw_perfect_match(node, center)
				MatchType.WRONG_POS:
					_draw_wrong_pos(node, center)
			index += 1

func _draw_perfect_match(node: CanvasItem, center: Vector2) -> void:
	node.draw_circle(center, RESULT_RADIUS , Color.WHITE, true)

func _draw_wrong_pos(node: CanvasItem, center: Vector2) -> void:
	node.draw_circle(center, RESULT_RADIUS , Color.DIM_GRAY, false, 3)

func _draw_no_match(node: CanvasItem, center: Vector2) -> void:
	node.draw_circle(center, RESULT_RADIUS * .1, Color.BLACK, true)
