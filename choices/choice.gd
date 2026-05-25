class_name Choice extends Resource

@export var text: String
@export var background_color : Color
@export var text_color := Color.BLACK

static var font : Font

const DRAW_RADIUS = 30

func remote_draw(node: CanvasItem, center: Vector2) -> void:
	_common_draw(node, center, background_color, text_color, text)

static func _common_draw(node: CanvasItem, center: Vector2, bg_color: Color, tx_color: Color, string: String) -> void:
	node.draw_circle(center, DRAW_RADIUS, bg_color)
	if font == null:
		font = node.get_theme_default_font()
	node.draw_string(font, center, string, HORIZONTAL_ALIGNMENT_CENTER,
	-1, 16, 
	tx_color)

static func remote_void_draw(node: CanvasItem, center: Vector2) -> void:
	_common_draw(node, center, Color.WEB_GRAY, Color.BLUE, "_")
