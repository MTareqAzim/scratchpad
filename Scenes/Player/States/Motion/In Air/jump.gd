extends "in_air.gd"

export (int) var MAX_SPEED := 400
export (int) var MAX_JUMP_HEIGHT := 100
export (int) var MIN_JUMP_HEIGHT := 50
export (float) var JUMP_DURATION := 0.5

var _prev_gravity : int

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	_prev_gravity = owner.get_grav()
	var velocity = Vector3(input_direction.x, input_direction.y, 0). normalized() * MAX_SPEED
	var new_gravity = int(round((2 * MAX_JUMP_HEIGHT) / pow(JUMP_DURATION, 2)))
	var z_vel = -new_gravity * JUMP_DURATION
	velocity.z = z_vel
	owner.set_grav(new_gravity)
	owner.set_velocity(velocity)
	
	.enter()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_x"):
		emit_signal("finished", "air dash")
		action_buffer.add_event("air_dashed")
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_y"):
		emit_signal("finished", "air back dash")
		action_buffer.add_event("air_dashed")
		get_tree().set_input_as_handled()
	
	.handle_input(event)


func update(delta: float) -> void:
	if owner.get_velocity().z > 0:
		emit_signal("finished", "previous")
	
	if not Input.is_action_pressed("ui_a"):
		_limit_z_velocity()
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	move_2d(input_direction, MAX_SPEED)
	
	.update(delta)


func exit():
	owner.set_grav(_prev_gravity)
	.exit()


func _limit_z_velocity() -> void:
	var min_jump_velocity = -sqrt(2 * owner.get_grav() * MIN_JUMP_HEIGHT)
	if owner.get_velocity().z < min_jump_velocity:
		var new_velocity = owner.get_velocity()
		new_velocity.z = min_jump_velocity
		owner.set_velocity(new_velocity)