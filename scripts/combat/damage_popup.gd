extends Control
class_name DamagePopup

onready var popup: Label = get_node("Text")
onready var tween: Tween = get_node("Tween")

var initial_rect_global_position: Vector2

var type: String
var value: String

export(Color) var heal_color
export(Color) var damage_color

func _ready() -> void:
	randomize()
	initial_rect_global_position = popup.rect_global_position
	interpolate_popup()
	
	
func interpolate_popup() -> void:
	var type_sign: String
	
	match type:
		"increase":
			type_sign = "+"
			popup.set("custom_colors/font_color", heal_color)
			
		"decrease":
			type_sign = "-"
			popup.set("custom_colors/font_color", damage_color)
			
	popup.text = type_sign + value
	
	var _interpolate_position: bool = tween.interpolate_property(
		popup,
		"rect_global_position",
		initial_rect_global_position,
		initial_rect_global_position + Vector2(0, -30),
		0.4
	)
	
	var _interpolate_alpha_color: bool = tween.interpolate_property(
		popup,
		"modulate:a",
		1.0,
		0.0,
		0.8,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
