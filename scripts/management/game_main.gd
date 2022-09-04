extends Node2D
class_name GameMain

onready var ally: Node2D = get_node("BattleManager/Ally")
onready var enemy: Node2D = get_node("BattleManager/Enemy")

var index: int = 0
var info_list: Dictionary = {}

export(Array, PackedScene) var ally_list
export(Array, PackedScene) var enemy_list

func _ready() -> void:
	randomize()
	spawn_ally()
	spawn_enemy()
	
	get_tree().call_group("bottom_container", "update_entity_info", info_list)
	
	
func spawn_ally() -> void:
	var ally_amount: int = randi() % ally.get_child_count() + 1
	for i in ally_amount:
		var ally_to_instance = ally_list[randi() % ally_list.size()].instance()
		ally.get_child(i).add_child(ally_to_instance)
		info_list[index] = ally_to_instance.info_dict
		index += 1
		
		
func spawn_enemy() -> void:
	var enemy_amount: int = randi() % enemy.get_child_count() + 1
	for i in enemy_amount:
		var enemy_to_instance = enemy_list[randi() % enemy_list.size()].instance()
		enemy.get_child(i).add_child(enemy_to_instance)
		info_list[index] = enemy_to_instance.info_dict
		index += 1
