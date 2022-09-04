extends Node2D
class_name GameMain

onready var ally: Node2D = get_node("BattleManager/Ally")
onready var enemy: Node2D = get_node("BattleManager/Enemy")

export(Array, PackedScene) var ally_list
export(Array, PackedScene) var enemy_list

func _ready() -> void:
	randomize()
	spawn_ally()
	spawn_enemy()
	
	
func spawn_ally() -> void:
	var ally_amount: int = randi() % ally.get_child_count() + 1
	for i in ally_amount:
		var ally_to_instance = ally_list[randi() % ally_list.size()].instance()
		ally.get_child(i).add_child(ally_to_instance)
		
		
func spawn_enemy() -> void:
	var enemy_amount: int = randi() % enemy.get_child_count() + 1
	for i in enemy_amount:
		var enemy_to_instance = enemy_list[randi() % enemy_list.size()].instance()
		enemy.get_child(i).add_child(enemy_to_instance)
