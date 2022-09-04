extends Control
class_name Enemy

onready var stats: Node = get_node("Stats")

var info_dict: Dictionary = {
	"type": "enemy"
}

var respective_slot = null

export(String) var faceset_path

func _ready() -> void:
	info_dict["hp"] = stats.health
	info_dict["max_hp"] = stats.max_health
	info_dict["mp"] = stats.mana
	info_dict["max_mp"] = stats.max_mana
	
	info_dict["self"] = self
	info_dict["faceset"] = faceset_path
	
	
func on_mouse_entered() -> void:
	if global_data.seeking_target:
		modulate.a = 0.5
		global_data.target = self
		
		
func on_mouse_exited() -> void:
	modulate.a = 1.0
	global_data.target = null
