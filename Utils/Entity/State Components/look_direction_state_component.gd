extends EntityStateComponent
class_name LookDirectionStateComponent, "look_direction.png"

onready var _look_direction : LookDirection = get_node(look_direction)
onready var _input_handler : InputHandler = get_node(input_handler)

export (NodePath) var look_direction
export (NodePath) var input_handler


func update(delta: float) -> void:
	var look_direction = _input_handler.get_direction()
	_update_look_direction(look_direction)


func _update_look_direction(direction: Vector2) -> void:
	if _look_direction.get_look_direction() == direction:
		return
	
	_look_direction.set_look_direction(direction)