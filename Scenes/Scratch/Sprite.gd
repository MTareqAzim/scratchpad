extends KinematicBody2D

const SPEED = 200

var motion = Vector2()
var facing_right = true

func _physics_process(delta):
	var x_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("ui_right"):
		facing_right = true
	elif Input.is_action_just_pressed("ui_left"):
		facing_right = false
	else:
		if x_strength > 0 and not facing_right:
			facing_right = true
		elif x_strength < 0 and facing_right:
			facing_right = false
	
	if facing_right and Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	elif not facing_right and Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	
	
	motion = move_and_slide(motion)
