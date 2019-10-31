extends StateComponent
class_name KinematicStateComponent, "kinematic_state_component.png"

onready var body : KinematicBody2P5D = get_node(_body_path)

export (NodePath) var _body_path


func get_class() -> String:
	return "KinematicStateComponent"


func is_class(type: String) -> bool:
	return type == "KinematicStateComponent" or .is_class(type)