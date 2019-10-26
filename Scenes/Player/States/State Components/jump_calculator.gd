extends Node

export (int) var MAX_JUMP_HEIGHT := 100
export (float) var JUMP_DURATION := 0.5

func _ready():
	var new_gravity = int(round((2 * MAX_JUMP_HEIGHT) / pow(JUMP_DURATION, 2)))
	var z_velocity = int(-new_gravity * JUMP_DURATION)
	
	$"Enter Gravity".new_value = new_gravity
	$"Enter Z Velocity".new_value = z_velocity