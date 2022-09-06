extends TextureRect
class_name HealthBarContainer

onready var health_bar: TextureProgress = get_node("Bar")

func init_container(max_value: int) -> void:
	health_bar.max_value = max_value
	health_bar.value = max_value
	
	
func update_bar(new_value: int) -> void:
	health_bar.value = new_value
