extends Control
class_name Character

onready var stats: Stats = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")

var info_dict: Dictionary = {
	"type": "ally"
}

var target = null
var respective_slot = null
var can_attack: bool = false

var attack_damage: int

export(String) var faceset_path

func _ready() -> void:
	info_dict["hp"] = stats.health
	info_dict["max_hp"] = stats.max_health
	info_dict["mp"] = stats.mana
	info_dict["max_mp"] = stats.max_mana
	
	info_dict["self"] = self
	info_dict["faceset"] = faceset_path
	
	
func _process(_delta: float) -> void:
	if not can_attack:
		return
		
	target = global_data.target
	global_data.seeking_target = true
	if Input.is_action_just_pressed("ui_click") and target != null:
		can_attack = false
		attack("normal", target)
		global_data.seeking_target = false
		
		
func update_health(damage: int) -> void:
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	respective_slot.update_health(stats.health)
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
	
	
func spawn_projectile(attack_type: String) -> void:
	var effect_path: String
	
	if attack_type == "normal":
		stats.mana += stats.mana_per_attack
		respective_slot.update_mana(stats.mana)
		effect_path = "res://scenes/env/effect_1.tscn"
		
	if attack_type == "special":
		stats.mana = 0
		respective_slot.update_mana(stats.mana)
		effect_path = "res://scenes/env/effect_2.tscn"
		
	var effect = load(effect_path).instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = target.get_parent().global_position
	
	target.update_health(attack_damage)
	
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" and stats.health == 0:
		respective_slot.entity_killed()
		queue_free()
		return
		
	if anim_name == "hit":
		get_tree().call_group("bottom_container", "change_entity")
		
	animation.play("idle")
