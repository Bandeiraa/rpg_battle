extends HBoxContainer
class_name SlotContainer

onready var faceset: TextureRect = get_node("Faceset")
onready var hp_value_label: Label = get_node("VContainer/HPContainer/Value")
onready var mp_value_label: Label = get_node("VContainer/MPContainer/Value")

func update_container(hp: int, mp: int, faceset_texture: StreamTexture) -> void:
	hp_value_label.text = str(hp)
	mp_value_label.text = str(mp)
	faceset.texture = faceset_texture
