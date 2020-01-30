extends EntityStateComponent

export (String) var body_key = "body"
export (String) var input_handler_key = "input"
export (String) var min_jump_height_key = "min_jump_height"

var _body
var _input : InputHandler
var _min_jump_height : int


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		_limit_z_velocity()


func update(delta: float) -> void:
	if not _input.is_action_pressed("jump"):
		_limit_z_velocity()


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input = component_state.get_dependency(input_handler_key)


func assign_variables() -> void:
	_min_jump_height = component_state.get_variable(min_jump_height_key)


func _limit_z_velocity() -> void:
	var min_jump_velocity = -sqrt(2 * _body.get_grav() * _min_jump_height)
	if _body.get_velocity().z < min_jump_velocity:
		_body.set_z_velocity(min_jump_velocity)
