extends Node2D
class_name Character

onready var stats: Stats = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")

func update_health(damage: int) -> void:
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	if stats.health == 0:
		#kill
		return
		
	animation.play("hit")
	
	
func on_animation_finished(_anim_name: String) -> void:
	animation.play("idle")
