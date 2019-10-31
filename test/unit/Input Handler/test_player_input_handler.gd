extends "res://addons/gut/test.gd"

var player_input : PlayerInputHandler

func before_each():
	player_input = PlayerInputHandler.new()

func after_each():
	for child in get_children():
		child.free()
	
	for action in InputMap.get_actions():
		Input.action_release(action)

func before_all():
	pass

func after_all():
	pass

func test_player_input():
	add_child(player_input)
	
	Input.action_press("ui_up")
	
	assert_eq(player_input.get_direction(), Vector2(0, -1))
	
	Input.action_release("ui_up")
	
	assert_eq(player_input.get_direction(), Vector2(0, 0))
	
	Input.action_press("ui_down")
	Input.action_press("ui_left")
	
	assert_eq(player_input.get_direction(), Vector2(-1, 1))