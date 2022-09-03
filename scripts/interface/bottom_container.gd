extends Control
class_name BottomContainer

onready var current: TextureRect = get_node("Current")
onready var action_container: GridContainer = get_node("ActionContainer")

func _ready() -> void:
	for button in action_container.get_children():
		button.connect("pressed", self, "on_button_pressed", [button])
		button.connect("mouse_exited", self, "mouse_interaction", [button, "exited"])
		button.connect("mouse_entered", self, "mouse_interaction", [button, "entered"])
		
		
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
