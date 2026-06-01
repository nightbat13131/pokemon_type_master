@tool
class_name Choice extends Resource

@export var text: String : set = set_text
@export var background_color : Color : set = set_bg_color
@export var text_color := Color.BLACK : set = set_text_color

static var font : Font

const DRAW_RADIUS = 30

func remote_draw(node: CanvasItem, center: Vector2) -> void:
	_common_draw(node, center, background_color, text_color, text)

#func get_type_result(_attacker: Choice) -> Guess.TypingMatch: return Guess.TypingMatch.NA

static func _common_draw(node: CanvasItem, center: Vector2, bg_color: Color, tx_color: Color, string: String) -> void:
	node.draw_circle(center, DRAW_RADIUS, bg_color)
	if font == null:
		font = node.get_theme_default_font()
	node.draw_string(font, center, string, HORIZONTAL_ALIGNMENT_CENTER,
	-1, 16, 
	tx_color)

static func remote_void_draw(node: CanvasItem, center: Vector2) -> void:
	_common_draw(node, center, Color.WEB_GRAY, Color.BLUE, "_")

func set_text(string: String) -> void: text = string

func set_bg_color(color: Color) -> void: background_color = color

func set_text_color(color: Color) -> void: text_color = color
