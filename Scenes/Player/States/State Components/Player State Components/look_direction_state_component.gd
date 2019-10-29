tool
extends PlayerStateComponent
class_name LookDirectionStateComponent

onready var _look_direction : KinematicBody2P5D = get_node(look_direction)

export (NodePath) var look_direction


func update(delta: float) -> void:
	var look_direction = _get_input_direction()
	update_look_direction(look_direction)


func _get_input_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input_direction


func update_look_direction(direction: Vector2) -> void:
	if direction and _look_direction.get_look_direction() != direction:
		_look_direction.set_look_direction(direction)