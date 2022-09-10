extends AudioStreamPlayer
class_name BackgroundMusic

var maximum_index: int = 16

var theme: String = "theme_"
var base_path: String = "res://assets/music/"

func _ready() -> void:
	randomize()
	
	
func stream_random_music() -> void:
	var random_index: int = randi() % maximum_index + 1
	var sound_to_stream: String = base_path + theme + str(random_index) + ".ogg"
	
	set_stream(load(sound_to_stream))
	play()
	
	
func on_background_music_finished() -> void:
	stream_random_music()
