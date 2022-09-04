extends Control
class_name Enemy

onready var stats: Node = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")

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
	target = target_list[randi() % target_list.size()]
	
	attack_damage = rng.randi_range(
		stats.normal_attack_gap.min(),
		stats.normal_attack_gap.max()
	)
	
	if stats.mana == stats.max_mana:
		attack_name = "special"
		
		attack_damage = rng.randi_range(
			stats.special_attack_gap.min(),
			stats.special_attack_gap.max()
		)
		
		stats.mana = 0
		
	#stats.mana += 3
	animation.play(attack_name)
	
	
func spawn_projectile() -> void:
	target.update_health(attack_damage)
	
	
func update_health(damage: int) -> void:
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	respective_slot.update_health(stats.health)
	animation.play("hit")
	
	
func on_mouse_entered() -> void:
	if global_data.seeking_target:
		modulate.a = 0.5
		global_data.target = self
		
		
func on_mouse_exited() -> void:
	modulate.a = 1.0
	global_data.target = null
	
	
func on_animation_finished(anim_name: String) -> void:
	var action: bool = (
		anim_name == "normal" or
		anim_name == "special"
	)
	
	if action:
		get_tree().call_group("bottom_container", "change_entity")
		
	if anim_name == "hit" and stats.health == 0:
		respective_slot.entity_killed()
		queue_free()
		
	animation.play("idle")
