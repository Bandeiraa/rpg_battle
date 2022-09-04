extends TextureRect
class_name CurrentEntity

onready var tween: Tween = get_node("Tween")

var entity_count: int = 0
var current_index: int = -1

var current_rect_position_list: Array = [
	Vector2(28, 80),
	Vector2(62, 80),
	Vector2(96, 80),
	Vector2(130, 80),
	Vector2(164, 80),
	Vector2(198, 80)
]

func _ready() -> void:
	rect_position = current_rect_position_list[current_index]
	
	
func update_index() -> void:
	current_index += 1
	if current_index > entity_count - 1:
		current_index = 0
		
		
func interpolate_position() -> void:
	var _move: bool = tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		current_rect_position_list[current_index],
		0.4
	)
	
	var _start: bool = tween.start()
