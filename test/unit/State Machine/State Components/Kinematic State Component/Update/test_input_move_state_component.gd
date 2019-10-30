extends "res://addons/gut/test.gd"

var input_move : InputMoveStateComponent

func before_each():
	input_move = InputMoveStateComponent.new()

func after_each():
	for child in get_children():
		child.free()
	
	for action in InputMap.get_actions():
		Input.action_release(action)

func before_all():
	pass

func after_all():
	pass

func test_move():
	var doubled_body : KinematicBody2P5D = double(KinematicBody2P5D).new()
	add_child(doubled_body)
	
	input_move._body_path = doubled_body.get_path()
	add_child(input_move)
	
	input_move.update(0.1)
	assert_called(doubled_body, "set_velocity_2d")

func test_move_inputs():
	var doubled_body : KinematicBody2P5D = double(KinematicBody2P5D).new()
	add_child(doubled_body)
	
	input_move._body_path = doubled_body.get_path()
	var max_speed = 300
	input_move.max_speed = max_speed
	add_child(input_move)
	
	Input.action_press("ui_down")
	input_move.update(0.1)
	var velocity = Vector2(0, 1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	Input.action_press("ui_down")
	Input.action_press("ui_up")
	input_move.update(0.1)
	velocity = Vector2()
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	Input.action_release("ui_down")
	Input.action_press("ui_up")
	Input.action_press("ui_left")
	input_move.update(0.1)
	velocity = Vector2(-1, -1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])