extends NodeStateComponent

export (int) var min_jump_height := 50


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		_limit_z_velocity()


func _limit_z_velocity() -> void:
	if node as KinematicBody2P5D:
		var min_jump_velocity = -sqrt(2 * node.get_grav() * min_jump_height)
		if node.get_velocity().z < min_jump_velocity:
			node.set_z_velocity(min_jump_velocity)
