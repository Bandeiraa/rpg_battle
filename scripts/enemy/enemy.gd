extends Control
class_name Enemy

onready var stats: Node = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")
onready var health_bar_container: TextureRect = get_node("BarBackground")

var can_attack: bool = false

var info_dict: Dictionary = {
	"type": "enemy"
}

var target = null
var respective_slot = null

var attack_damage: int

export(String) var faceset_path

func _ready() -> void:
	randomize()
	
	info_dict["hp"] = stats.health
	info_dict["max_hp"] = stats.max_health
	info_dict["mp"] = stats.mana
	info_dict["max_mp"] = stats.max_mana
	
	info_dict["self"] = self
	info_dict["faceset"] = faceset_path
	
	health_bar_container.init_container(stats.max_health)
	
	
func _process(_delta: float) -> void:
	if not can_attack:
		return
		
	attack()
	can_attack = false
	
	
func attack() -> void:
	var attack_name: String = "normal"
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var target_list: Array = global_data.ally_list
	if target_list.empty():
		return
		
	target = target_list[randi() % target_list.size()]
	
	attack_damage = rng.randi_range(
		stats.normal_attack_gap.min(),
		stats.normal_attack_gap.max()
	)
	
	if stats.mana >= stats.max_mana:
		attack_name = "special"
		
		attack_damage = rng.randi_range(
			stats.special_attack_gap.min(),
			stats.special_attack_gap.max()
		)
		
	animation.play(attack_name)
	
	
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
	
	
func update_health(damage: int) -> void:
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	respective_slot.update_health(stats.health)
	health_bar_container.update_bar(stats.health)
	animation.play("hit")
	
	
func on_mouse_entered() -> void:
	if global_data.seeking_target:
		modulate.a = 0.5
		global_data.target = self
		
		
func on_mouse_exited() -> void:
	modulate.a = 1.0
	global_data.target = null
	
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" and stats.health == 0:
		respective_slot.entity_killed()
		queue_free()
		return
		
	if anim_name == "hit":
		get_tree().call_group("bottom_container", "change_entity")
		
	animation.play("idle")
