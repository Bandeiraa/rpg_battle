extends GridContainer
class_name ActionContainer

onready var attack_button: TextureButton = get_node("Attack")
onready var defense_button: TextureButton = get_node("Defense")
onready var special_button: TextureButton = get_node("Special")

func _ready() -> void:
	disable_buttons()
	
	
func update_container(type: String, dict: Dictionary) -> void:
	match type:
		"ally":
			enable_buttons(dict)
			
		"enemy":
			disable_buttons()
			
			
func enable_buttons(dict: Dictionary) -> void:
	attack_button.disabled = false
	defense_button.disabled=  false
	
	var entity = dict["self"]
	var entity_stats: Node = entity.stats
	if entity_stats.mana >= entity_stats.max_mana:
		special_button.disabled = false
		
	show()
	
	
func disable_buttons() -> void:
	hide()
	
	for button in get_children():
		button.disabled = true
