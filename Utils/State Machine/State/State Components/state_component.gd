extends Node
class_name StateComponent, "state_component.png"

export (bool) var active := true setget set_active

var component_state = null


func _get_configuration_warning() -> String:
	var ancestor : Node = get_parent()
	while ancestor != owner:
		if ancestor is State:
			return ""
		ancestor = ancestor.get_parent()
	
	return "Must be part of a State."


func get_class() -> String:
	return "StateComponent"


func is_class(type: String) -> bool:
	return type == "StateComponent" or .is_class(type)


func set_active(new_active: bool) -> void:
	active = new_active