extends AudioStreamPlayer
class_name SoundEffect

func stream_sfx(sfx_path: String) -> void:
	set_stream(load(sfx_path))
	play()
	
	
func on_sfx_finished() -> void:
	queue_free()
