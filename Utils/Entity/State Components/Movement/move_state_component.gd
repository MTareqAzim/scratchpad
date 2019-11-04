extends EntityStateComponent
class_name MoveStateComponent, "move_state_component.png"

onready var _body : KinematicBody2P5D = get_node(body)
onready var _input_handler : InputHandler = get_node(input_handler)

export (NodePath) var body : NodePath
export (NodePath) var input_handler : NodePath
export (int) var max_speed := 0


func update(delta: float) -> void:
	var input_direction = _input_handler.get_direction()
	_move_2d(input_direction, max_speed)


func _move_2d(direction: Vector2, speed: int) -> void:
	var velocity_2d = direction.normalized() * speed
	_body.set_velocity_2d(velocity_2d)
