extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

export (String) var body_key := "body"
export (String) var input_handler_key := "input"
export (String) var max_speed_key := "max_speed"

var _body
var _input_handler : InputHandler
var _max_speed : int = 0


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	_move_2d(input_direction, _max_speed)


func assign_dependencies() -> void:
	_body = component_state.get_dependency(body_key)
	_input_handler = component_state.get_dependency(input_handler_key)


func assign_variables() -> void:
	_max_speed = component_state.get_variable(max_speed_key)


func _move_2d(direction: Vector2, speed: int) -> void:
	var isometric_direction = direction
	isometric_direction.y = isometric_direction.y / 2
	
	var velocity_2d = isometric_direction.normalized() * speed
	
	_body.set_velocity_2d(velocity_2d)
