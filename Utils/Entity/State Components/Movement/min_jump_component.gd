extends EntityStateComponent

onready var _body : KinematicBody2P5D = get_node(body)
onready var _input : InputHandler = get_node(input)

export (NodePath) var body
export (NodePath) var input
export (int) var min_jump_height := 50


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		_limit_z_velocity()


func update(delta: float) -> void:
	if not _input.is_action_pressed("jump"):
		_limit_z_velocity()


func _limit_z_velocity() -> void:
	var min_jump_velocity = -sqrt(2 * _body.get_grav() * min_jump_height)
	if _body.get_velocity().z < min_jump_velocity:
		_body.set_z_velocity(min_jump_velocity)
