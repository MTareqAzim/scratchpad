extends EntityStateComponent

export (String) var body_key
export (int) var crouch_height := 50

var _body : KinematicBody2P5D


func enter() -> void:
	$"Enter Height".new_value = crouch_height
	$"Exit Height".new_value = _body.get_height()


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)