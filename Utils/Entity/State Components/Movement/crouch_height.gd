extends EntityStateComponent

onready var _body : KinematicBody2P5D = get_node(body)

export (NodePath) var body
export (int) var crouch_height := 50


func enter() -> void:
	$"Enter Height".new_value = crouch_height
	$"Exit Height".new_value = _body.get_height()