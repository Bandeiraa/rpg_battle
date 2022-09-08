extends Node
class_name GlobalData

var target = null
var seeking_target: bool = false

var ally_list: Array

func reset() -> void:
	target = null
	ally_list = []
	seeking_target = false
