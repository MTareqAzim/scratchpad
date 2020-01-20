extends KinematicBody2D

var direction : Vector2 = Vector2(0, 0)

func _physics_process(delta):
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move_and_slide(direction * 300)


func _input(event):
	if event.is_action_pressed("ui_select"):
		get_parent().get_node("Area2D").call_deferred("_enable_collisions")