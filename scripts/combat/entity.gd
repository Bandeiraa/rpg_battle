extends Control
class_name Entity

onready var stats: Node = get_node("Stats")
onready var animation: AnimationPlayer = get_node("Animation")
onready var health_bar_container: TextureRect = get_node("BarBackground")

var target = null
var respective_slot = null

var attack_damage: int

var can_attack: bool = false

var info_dict: Dictionary = {}

export(String) var class_type #ally/enemy
export(String) var faceset_path

func _ready() -> void:
	randomize()
	populate_info_dict()
	health_bar_container.init_container(stats.max_health)
	var _animation_finished: bool = animation.connect("animation_finished", self, "on_animation_finished")
	
	
func populate_info_dict() -> void:
	info_dict["hp"] = stats.health
	info_dict["max_hp"] = stats.max_health
	info_dict["mp"] = stats.mana
	info_dict["max_mp"] = stats.max_mana
	
	info_dict["self"] = self
	info_dict["type"] = class_type
	info_dict["faceset"] = faceset_path
	
	
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
	
	
func update_health(_damage: int) -> void:
	pass
	
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" and stats.health == 0:
		respective_slot.entity_killed()
		free_list_reference()
		return
		
	if anim_name == "hit":
		get_tree().call_group("bottom_container", "change_entity")
		
	animation.play("idle")
	
	
func free_list_reference() -> void:
	queue_free()
