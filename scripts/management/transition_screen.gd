extends CanvasLayer
class_name Transition

signal start_scene

onready var animation: AnimationPlayer = get_node("Animation")

var target_scene: String

func fade_in(scene_path: String) -> void:
	target_scene = scene_path
	
	animation.play("fade_in")
	
	
func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			var _change_scene: bool = get_tree().change_scene(target_scene)
			animation.play("fade_out")
			
		"fade_out":
			emit_signal("start_scene")
