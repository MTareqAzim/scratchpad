extends Node

export (int) var max_jump_height := 100 setget set_max_jump_height
export (float) var jump_duration := 0.5 setget set_jump_duration

func _ready():
	_set_values()


func set_max_jump_height(new_jump_height: int) -> void:
	max_jump_height = new_jump_height
	call_deferred("_set_values")


func set_jump_duration(new_jump_duration: float) -> void:
	jump_duration = new_jump_duration
	call_deferred("_set_values")


func _set_values():
	var new_gravity = int(round((2 * max_jump_height) / pow(jump_duration, 2)))
	var z_velocity = int(-new_gravity * jump_duration)
	
	$"Enter Gravity".new_value = new_gravity
	$"Enter Z Velocity".new_value = z_velocity