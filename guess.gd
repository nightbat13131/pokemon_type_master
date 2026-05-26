class_name Guess extends Answer

const UNIT = DisplayChoice.SIZE.x *.5
const RESULT_RADIUS = UNIT *.45

static var _type_pairings : Array[TypePairs]
static var _tester : PairingTester

enum MatchType {
	NO_MATCH = 0,
	PERFECT = 1, 
	WRONG_POS = 2, 
}

enum TypingMatch {
	INVALID = -1,
	NA = 0,
	WIN = 1,
	LOSS = 2
}

var _results_match : Array[MatchType]
var _results_type : Array[TypingMatch]

func check_answer(answer: Answer) -> void:
	assert(answer.size() == self.size())
	var _answer : Array[Choice] = answer.get_copy_choices()
	var _guess : Array[Choice] = self.get_copy_choices()
	var current_answer : Choice
	var current_guess: Choice
	for index in range(size()):
		current_answer = _answer[index]
		current_guess = _guess[index]
		_results_type.append(_tester.attack_result(current_guess, current_answer))
		if current_answer == current_guess:
			_results_match.append(MatchType.PERFECT)
			_answer[index] = null
			_guess[index] = null
	for remaining_guess in _guess:
		if remaining_guess != null:
			if _answer.has(remaining_guess):
				_results_match.append(MatchType.WRONG_POS)
				_answer.erase(remaining_guess)
	for remaining_answer in _answer:
		if remaining_answer != null:
			_results_match.append(MatchType.NO_MATCH)
	#print(_results_match)
	print(_results_type)

func is_correct() -> bool:
	assert(!_results_match.is_empty())
	for result in _results_match:
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
			match _results_match[index]:
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

static func set_type_pairings(list: Array[TypePairs]) -> void:
	_type_pairings = list
	_tester = PairingTester.new(list)

static func draw_match_type(node: CanvasItem, type_match: TypingMatch ) -> void:
	var text := ""
	match type_match:
		TypingMatch.NA, TypingMatch.INVALID:
			return
		TypingMatch.WIN:
			text = "W"
		TypingMatch.LOSS:
			text = "L"
		_: 
			"?"
	var font : Font = node.get_theme_default_font()
	node.draw_char(font, Vector2.DOWN * 15, text)

func apply_display_index(node: DisplayChoice, index: int) -> void:
	node.set_choice(get_choice(index))
	node.set_result_type(_results_type.get(index))
	node.set_index(index)

class PairingTester:
	var _type_pairings : Array[TypePairs]
	var _type_pairs : Dictionary[Choice, Array]
	
	func _init(pairings: Array[TypePairs]) -> void:
		_type_pairings = pairings
		_type_pairs = {}
	
	func attack_result(attacker: Choice, defender: Choice) -> TypingMatch:
		if _type_pairings.is_empty():
			return Guess.TypingMatch.NA
		if !_type_pairs.keys().has(attacker):
			_populate_dictionary(attacker)
		var temp_ : TypingMatch
		for each_pair: TypePairs in _type_pairs[attacker]:
			temp_ = each_pair.get_results(attacker, defender)
			if ![TypingMatch.NA, TypingMatch.INVALID].has(temp_):
				return temp_
		return TypingMatch.NA

	func _populate_dictionary(focus: Choice):
		assert(!_type_pairs.keys().has(focus))
		_type_pairs[focus] = []
		for pairing in _type_pairings:
			if pairing.is_included(focus):
				_type_pairs[focus].append(pairing)
		
