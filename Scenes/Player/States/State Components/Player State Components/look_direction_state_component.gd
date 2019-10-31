tool
extends PlayerStateComponent
class_name LookDirectionStateComponent

onready var _look_direction : KinematicBody2P5D = get_node(look_direction)
onready var _input_handler : InputHandler = get_node(input_handler)

export (NodePath) var look_direction
export (NodePath) var input_handler


func update(delta: float) -> void:
	var look_direction = _input_handler.get_direction()
	update_look_direction(look_direction)


func update_look_direction(direction: Vector2) -> void:
	if direction and _look_direction.get_look_direction() != direction:
		_look_direction.set_look_direction(direction)