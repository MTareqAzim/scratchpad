extends EntityStateComponent

export (String) var body_key := "body"
export (String) var crouch_height_key := "crouch_height"

var _body : KinematicBody2P5D
var _crouch_height : int = 50


func enter() -> void:
	$"Enter Height".args = [_crouch_height]
	$"Exit Height".args = [_body.get_height()]


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)


func assign_variables() -> void:
	_crouch_height = component_state.get_variable(crouch_height_key)