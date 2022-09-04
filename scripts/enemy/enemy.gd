extends Node2D
class_name Enemy

onready var stats: Node = get_node("Stats")

var info_dict: Dictionary = {
	"type": "enemy"
}

func _ready() -> void:
	info_dict["hp"] = stats.health
	info_dict["max_hp"] = stats.max_health
	info_dict["mp"] = stats.mana
	info_dict["max_mp"] = stats.max_mana
