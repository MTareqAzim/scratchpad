tool
extends KinematicStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (int) var max_speed := 0


func handle_input(event) -> void:
	if event.is_action_pressed("ui_right") \
	or event.is_action_pressed("ui_left") \
	or event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_down"):
		get_tree().set_input_as_handled()


func update(delta: float) -> void:
	var input_direction = _get_input_direction()
	_move_2d(input_direction, max_speed)


func _get_input_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input_direction


func _move_2d(direction: Vector2, speed: int) -> void:
	var velocity_2d = direction.normalized() * speed
	body.set_velocity_2d(velocity_2d)
