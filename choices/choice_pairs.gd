class_name TypePairs extends Resource

@export var a_ : Choice
@export var b_ : Choice
@export var a_b_result : Guess.TypingMatch
@export var b_a_result : Guess.TypingMatch

var _both : Array[Choice] : get = get_both

func get_results(attacker: Choice, defender: Choice) -> Guess.TypingMatch:
	if a_ == attacker and b_ == defender:
		return a_b_result
	elif a_ == defender and b_ == attacker:
		return b_a_result
	return Guess.TypingMatch.INVALID

func is_included(focus: Choice) -> bool: return _both.has(focus)

func get_both() -> Array[Choice]:
	if _both.is_empty():
		_both.append(a_)
		_both.append(b_)
	return _both
