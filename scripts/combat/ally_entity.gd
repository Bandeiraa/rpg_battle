extends Entity
class_name AllyEntity

var can_defend: bool = false
var can_special_attack: bool = false

func _process(_delta: float) -> void:
	if not can_attack and not can_special_attack:
		#global_data.seeking_target = false
		return
		
	target = global_data.target
	global_data.seeking_target = true
	
	if Input.is_action_just_pressed("ui_click") and target != null:
		attack(attack_type(), target)
		global_data.seeking_target = false
		
		
func attack_type() -> String:
	if can_attack:
		can_attack = false
		return "normal"
		
	if can_special_attack:
		can_special_attack = false
		return "special"
		
	return "normal"
	
	
func attack(attack_type: String, attack_target) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	target = attack_target
	
	match attack_type:
		"normal":
			attack_damage = rng.randi_range(
				stats.normal_attack_gap.min(), 
				stats.normal_attack_gap.max()
			)
			
		"special":
			attack_damage = rng.randi_range(
				stats.special_attack_gap.min(), 
				stats.special_attack_gap.max()
			)
			
	
	animation.play(attack_type)
	
	
func update_health(damage: int) -> void:
	if not can_defend:
		stats.health = clamp(stats.health - damage, 0, stats.max_health)
		
	if can_defend:
		can_defend = false
		# warning-ignore:integer_division
		stats.health = clamp(stats.health - damage / 2, 0, stats.max_health)
		
	respective_slot.update_health(stats.health)
	health_bar_container.update_bar(stats.health)
	
	animation.play("hit")
	
	
func free_list_reference() -> void:
	var index_in_list: int = global_data.ally_list.find(self)
	global_data.ally_list.remove(index_in_list)
	emit_signal("killed", class_type)
	queue_free()
