extends Camera2D
class_name LevelCamera

var lifetime: float
var strength: float

var is_shaking: bool = false

func shake(new_lifetime: float, new_strength: float) -> void:
	if is_shaking:
		return
		
	is_shaking = true
	
	lifetime = new_lifetime
	strength = new_strength
	
	while lifetime > 0:
		offset.x = rand_range(-strength, strength)
		offset.y = rand_range(strength, -strength)
		
		yield(get_tree(), "idle_frame")
		lifetime -= get_process_delta_time()
		
	is_shaking = false
	offset = Vector2.ZERO
