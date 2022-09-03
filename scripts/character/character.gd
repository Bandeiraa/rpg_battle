extends Node2D
class_name Character

onready var stats: Stats = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")

var target = null
var attack_damage: int

func update_health(damage: int) -> void:
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	if stats.health == 0:
		#kill
		return
		
	animation.play("hit")
	
	
func attack(attack_type: String, attack_target) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	target = attack_target
	
	match attack_type:
		"normal":
			attack_damage = rng.randi_range(
				stats.normal_attack_gap.min(), 
				stats.normal_attack_gap.max()
			)
			
		"special":
			attack_damage = rng.randi_range(
				stats.special_attack_gap.min(), 
				stats.special_attack_gap.max()
			)
			
	
	animation.play(attack_type)
	
	
func spawn_projectile() -> void:
	#target.update_health(attack_damage)
	pass
	
	
func on_animation_finished(_anim_name: String) -> void:
	animation.play("idle")
