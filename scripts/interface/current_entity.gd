extends TextureRect
class_name CurrentEntity

enum rect_list {
	POSITION,
	OBJECT
}

onready var tween: Tween = get_node("Tween")

var entity_count: int = 0
var current_index: int = 0

var current_rect_position_list: Array

export(NodePath) onready var turn_container = get_node(turn_container) as HBoxContainer
export(NodePath) onready var slot_container = get_node(slot_container) as HBoxContainer

func initialize_container() -> void:
	current_rect_position_list = [
		[Vector2(28, 80), turn_container.get_node("Slot1")],
		[Vector2(62, 80), turn_container.get_node("Slot2")],
		[Vector2(96, 80), turn_container.get_node("Slot3")],
		[Vector2(130, 80), turn_container.get_node("Slot4")],
		[Vector2(164, 80), turn_container.get_node("Slot5")],
		[Vector2(198, 80), turn_container.get_node("Slot6")]
	]
	
	rect_position = current_rect_position_list[current_index][rect_list.POSITION]
	update_slot_container()
	
	
func update_index() -> void:
	current_index += 1
	if current_index > entity_count - 1:
		current_index = 0
		
	if not current_rect_position_list[current_index][rect_list.OBJECT].is_alive:
		update_index()
		
		
func interpolate_position() -> void:
	var _move: bool = tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		current_rect_position_list[current_index][rect_list.POSITION],
		0.4
	)
	
	var _start: bool = tween.start()
	
	
func on_tween_finished() -> void:
	update_slot_container()
	
	
func update_slot_container() -> void:
	var slot: Control = current_rect_position_list[current_index][rect_list.OBJECT]
	
	var hp: int = slot.current_hp
	var mp: int = slot.current_mp
	var faceset: StreamTexture = slot.faceset
	
	slot_container.update_container(hp, mp, faceset)
	
	
func get_current_attacker():
	return current_rect_position_list[current_index][rect_list.OBJECT]
