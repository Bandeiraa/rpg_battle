extends Node2D
class_name GameMain

onready var ally: Node2D = get_node("BattleManager/Ally")
onready var enemy: Node2D = get_node("BattleManager/Enemy")

var index: int = 0

var ally_count: int
var enemy_count: int

var info_list: Array = []

export(Array, PackedScene) var ally_list
export(Array, PackedScene) var enemy_list

func _ready() -> void:
	randomize()
	spawn_ally()
	spawn_enemy()
	
	info_list.shuffle()
	get_tree().call_group("bottom_container", "update_entity_info", info_list)
	
	
func spawn_ally() -> void:
	var ally_amount: int = randi() % ally.get_child_count() + 1
	ally_count = ally_amount
	
	for i in ally_amount:
		var ally_to_instance = ally_list[randi() % ally_list.size()].instance()
		ally_to_instance.connect("killed", self, "on_entity_killed")
		ally.get_child(i).add_child(ally_to_instance)
		info_list.append(ally_to_instance.info_dict)
		global_data.ally_list.append(ally_to_instance)
		index += 1
		
		
func spawn_enemy() -> void:
	var enemy_amount: int = randi() % enemy.get_child_count() + 1
	enemy_count = enemy_amount
	
	for i in enemy_amount:
		var enemy_to_instance = enemy_list[randi() % enemy_list.size()].instance()
		enemy_to_instance.connect("killed", self, "on_entity_killed")
		enemy.get_child(i).add_child(enemy_to_instance)
		info_list.append(enemy_to_instance.info_dict)
		index += 1
		
		
func on_entity_killed(entity: String) -> void:
	match entity:
		"ally":
			ally_count -= 1
			
		"enemy":
			enemy_count -= 1
			
			
	if ally_count == 0:
		get_tree().paused = true
		
	if enemy_count == 0:
		get_tree().paused = true
