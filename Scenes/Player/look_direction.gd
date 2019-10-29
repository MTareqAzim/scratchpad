tool
extends Node
class_name LookDirection

signal direction_changed(new_direction)

var _look_direction := Vector2(1, 0) setget set_look_direction, get_look_direction


func set_look_direction(new_look_direction: Vector2) -> void:
	_look_direction = new_look_direction
	emit_signal("direction_changed", new_look_direction)


func get_look_direction() -> Vector2:
	return _look_direction