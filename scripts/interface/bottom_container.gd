extends Control
class_name BottomContainer

signal enemy_turn

onready var current: TextureRect = get_node("Current")

onready var turn_container: HBoxContainer = get_node("TurnContainer")
onready var action_container: GridContainer = get_node("ActionContainer")

var info_list: Dictionary = {}

func _ready() -> void:
	for i in info_list.size():
		turn_container.get_child(i).show()
		
	for button in action_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		
		
func update_entity_info(list: Dictionary) -> void:
	info_list = list
	current.entity_count = info_list.size()
	change_entity()
	
	
func change_entity() -> void:
	current.update_index()
	current.interpolate_position()
	
	update_visible_entity()
	
	
func update_visible_entity() -> void:
	var current_dict: Dictionary = info_list[current.current_index]
	var type: String = current_dict["type"]
	
	if type == "ally":
		action_container.show()
		
	if type == "enemy":
		action_container.hide()
		emit_signal("enemy_turn")
		
		
func on_button_pressed(button: TextureButton) -> void:
	match button.name:
		"Attack":
			pass
			
		"Defense":
			pass
			
		"Special":
			pass
			
		"Run":
			pass
			
			
func mouse_interaction(button: TextureButton, type: String) -> void:
	match type:
		"entered":
			button.modulate.a = 0.5
			
		"exited":
			button.modulate.a = 1.0
