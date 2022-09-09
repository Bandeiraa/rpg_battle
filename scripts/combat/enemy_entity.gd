extends Entity
class_name EnemyEntity

func _process(_delta: float) -> void:
	if not can_attack:
		return
		
	attack()
	can_attack = false
	
	
func attack() -> void:
	var attack_name: String = "normal"
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var target_list: Array = global_data.ally_list
	if target_list.empty():
		return
		
	target = target_list[randi() % target_list.size()]
	
	attack_damage = rng.randi_range(
		stats.normal_attack_gap.min(),
		stats.normal_attack_gap.max()
	)
	
	if stats.mana >= stats.max_mana:
		attack_name = "special"
		
		attack_damage = rng.randi_range(
			stats.special_attack_gap.min(),
			stats.special_attack_gap.max()
		)
		
	animation.play(attack_name)
	
	
func update_health(damage: int) -> void:
	get_tree().call_group("level_camera", "shake", 0.25, 0.5)
	stats.health = clamp(stats.health - damage, 0, stats.max_health)
	respective_slot.update_health(stats.health)
	health_bar_container.update_bar(stats.health)
	animation.play("hit")
	
	spawn_damage_popup("decrease", str(damage))
	
	
func on_mouse_entered() -> void:
	if global_data.seeking_target:
		modulate.a = 0.5
		global_data.target = self
		
		
func on_mouse_exited() -> void:
	modulate.a = 1.0
	global_data.target = null
