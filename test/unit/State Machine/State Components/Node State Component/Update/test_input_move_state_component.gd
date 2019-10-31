extends "res://addons/gut/test.gd"

var input_move : MoveStateComponent

func before_each():
	input_move = MoveStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_move():
	var doubled_body : KinematicBody2P5D = double(KinematicBody2P5D).new()
	var input : InputHandler = InputHandler.new()
	add_child(doubled_body)
	add_child(input)
	
	input_move.node_path = doubled_body.get_path()
	input_move.input_handler = input.get_path()
	add_child(input_move)
	
	input_move.update(0.1)
	assert_called(doubled_body, "set_velocity_2d")

func test_move_inputs():
	var doubled_body : KinematicBody2P5D = double(KinematicBody2P5D).new()
	var doubled_input : InputHandler = double(InputHandler).new()
	add_child(doubled_body)
	add_child(doubled_input)
	
	input_move.node_path = doubled_body.get_path()
	input_move.input_handler = doubled_input.get_path()
	var max_speed = 300
	input_move.max_speed = max_speed
	add_child(input_move)
	
	stub(doubled_input, "get_direction").to_return(Vector2(0, 1))
	input_move.update(0.1)
	var velocity = Vector2(0, 1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	stub(doubled_input, "get_direction").to_return(Vector2(0, 0))
	input_move.update(0.1)
	velocity = Vector2()
	assert_called(doubled_body, "set_velocity_2d", [velocity])
	
	stub(doubled_input, "get_direction").to_return(Vector2(-1, -1))
	input_move.update(0.1)
	velocity = Vector2(-1, -1).normalized() * max_speed
	assert_called(doubled_body, "set_velocity_2d", [velocity])