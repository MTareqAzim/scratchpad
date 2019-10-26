extends StateComponent
class_name KinematicStateComponent, "kinematic_state_component.png"

export (NodePath) var _body_path

var body : KinematicBody2P5D

func _ready():
	body = get_node(_body_path)
