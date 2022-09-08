extends Control
class_name BottomContainer

onready var current: TextureRect = get_node("Current")

onready var turn_container: HBoxContainer = get_node("TurnContainer")
onready var action_container: GridContainer = get_node("ActionContainer")

var info_list: Array

func _ready() -> void:
	for button in action_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		
		
func update_entity_info(list: Array) -> void:
	show()
	
	info_list = list
	for i in info_list.size():
		turn_container.get_child(i).update_slot(info_list[i])
		
	current.entity_count = info_list.size()
	current.initialize_container()
	update_visible_entity()
	
	
func change_entity() -> void:
	current.update_index()
	current.interpolate_position()
	
	
func update_visible_entity() -> void:
	var current_dict: Dictionary = info_list[current.current_index]
	var type: String = current_dict["type"]
	
	if type == "ally":
		action_container.update_container(type, current_dict)
		
	if type == "enemy":
		action_container.update_container(type, current_dict)
		
		#attack cooldown, lol
		yield(get_tree().create_timer(1.0), "timeout")
		
		var attacker_slot = current.get_current_attacker()
		var attacker = attacker_slot.target
		if is_instance_valid(attacker):
			attacker.can_attack = true
			
			
func on_button_pressed(button: TextureButton) -> void:
	var attacker_slot = current.get_current_attacker()
	var attacker = attacker_slot.target
	
	match button.name:
		"Attack":
			attacker.can_attack = true
			
		"Defense":
			global_data.seeking_target = false
			attacker.can_attack = false
			attacker.can_defend = true
			change_entity()
			
		"Special":
			attacker.can_special_attack = true
			
		"Run":
			pass
			
			
func mouse_interaction(button: TextureButton, type: String) -> void:
	if button.disabled:
		return
		
	match type:
		"entered":
			button.modulate.a = 0.5
			
		"exited":
			button.modulate.a = 1.0
