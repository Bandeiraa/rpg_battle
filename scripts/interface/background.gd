extends CanvasLayer
class_name Background

onready var background: TextureRect = get_node("Texture")

var background_list_size: int = 24
var background_folder_path: String = "res://assets/background/"

func _ready() -> void:
	randomize()
	var random_background: int = randi() % background_list_size + 1
	background.texture = load(background_folder_path + str(random_background) + ".png")
