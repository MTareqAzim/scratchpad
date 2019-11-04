extends EntityStateComponent

onready var _body : KinematicBody2P5D = get_node(body)

export (NodePath) var body
export (int) var min_jump_height := 50


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		_limit_z_velocity()


func _limit_z_velocity() -> void:
	var min_jump_velocity = -sqrt(2 * body.get_grav() * min_jump_height)
	if body.get_velocity().z < min_jump_velocity:
		body.set_z_velocity(min_jump_velocity)
