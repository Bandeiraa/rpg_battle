extends Control
class_name EntitySlot

onready var health: TextureProgress = get_node("Health")
onready var mana: TextureProgress = get_node("Mana")

onready var faceset_rect: TextureRect = get_node("Faceset")

var target = null

var faceset: StreamTexture
var current_hp: int
var max_hp: int

var current_mp: int
var max_mp: int

var is_alive: bool = false

func update_slot(slot_info: Dictionary) -> void:
	faceset_rect.texture = load(slot_info["faceset"])
	faceset = faceset_rect.texture
	is_alive = true
	show()
	
	current_hp = slot_info["hp"]
	max_hp = slot_info["max_hp"]
	
	current_mp = slot_info["mp"]
	max_mp = slot_info["max_mp"]
	
	target = slot_info["self"]
	target.respective_slot = self
	
	init_health_bar()
	init_mana_bar()
	
	
func init_health_bar() -> void:
	health.max_value = max_hp
	health.value = current_hp
	
	
func init_mana_bar() -> void:
	mana.max_value = max_mp
	mana.value = current_mp
