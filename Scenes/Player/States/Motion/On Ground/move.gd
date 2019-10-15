extends "on_ground.gd"

export (int) var MAX_SPEED := 200


func enter() -> void:
	speed = 0
	velocity = Vector3()
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	.enter()


func update(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction == Vector2.ZERO:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)
	
	speed = MAX_SPEED
	move_2d(input_direction, speed)
	.update(delta)