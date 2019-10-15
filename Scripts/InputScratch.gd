extends Node2D

export (int) var speed := 0
export (int) var gravity := 98

onready var kinematic_body = get_parent()
var velocity := Vector3()

func _physics_process(delta):
	get_input()
	kinematic_body.set_velocity(velocity)


func get_input():
	var x_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var velocity_2D = Vector2(x_direction, y_direction).normalized() * speed
	
	var z_velocity = kinematic_body.get_velocity().z
	if kinematic_body.is_grounded():
		z_velocity = 0

	if Input.is_action_just_pressed("ui_a") and kinematic_body.is_grounded():
		z_velocity -= 1000
	
	if not kinematic_body.is_grounded():
		if z_velocity >= 0:
			z_velocity += gravity * 1.4
		else:
			z_velocity += gravity
	
	velocity = Vector3(velocity_2D.x, velocity_2D.y, z_velocity)