extends StateComponent
class_name NodeStateComponent, "node_state_component.png"

onready var node : Node = get_node(node_path)

export (NodePath) var node_path


func get_class() -> String:
	return "NodeStateComponent"


func is_class(type: String) -> bool:
	return type == "NodeStateComponent" or .is_class(type)