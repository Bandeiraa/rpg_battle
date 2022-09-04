extends Node2D
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
