extends Control
class_name Entity

signal killed

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

export(String) var normal_effect_path
export(String) var special_effect_path

export(Vector2) var spawn_position

export(PackedScene) var damage_popup
export(PackedScene) var sound_effect

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
		effect_path = normal_effect_path
		
	if attack_type == "special":
		stats.mana = 0
		respective_slot.update_mana(stats.mana)
		effect_path = special_effect_path
		
	var effect = load(effect_path).instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = target.get_parent().global_position
	
	target.update_health(attack_damage)
	
	
func update_health(_damage: int) -> void:
	pass
	
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" and stats.health == 0:
		spawn_sound_effect("res://assets/sound/17.ogg")
		respective_slot.entity_killed()
		free_list_reference()
		return
		
	if anim_name == "hit":
		get_tree().call_group("bottom_container", "change_entity")
		
	animation.play("idle")
	
	
func spawn_damage_popup(type: String, value: String) -> void:
	var damage_popup_to_instance = damage_popup.instance()
	
	damage_popup_to_instance.rect_global_position = rect_global_position + spawn_position
	damage_popup_to_instance.type = type
	damage_popup_to_instance.value = value
	
	get_tree().root.call_deferred("add_child", damage_popup_to_instance)
	
	
func spawn_sound_effect(sfx_path: String) -> void:
	var sfx = sound_effect.instance()
	get_tree().root.call_deferred("add_child", sfx)
	sfx.stream_sfx(sfx_path)
	
	
func free_list_reference() -> void:
	emit_signal("killed", class_type)
	queue_free()
