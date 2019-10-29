extends "res://addons/gut/test.gd"

var state_machine : StateMachine

func before_each():
	state_machine = StateMachine.new()

func after_each():
	for child in get_children():
		child.queue_free()

func before_all():
	pass

func after_all():
	pass

func test_populate_state_machine():
	var state_a = State.new()
	state_a.state_name = "state_a"
	var state_b = State.new()
	state_b.state_name = "state_b"
	var state_c = State.new()
	state_c.state_name = "state_c"
	
	state_machine.add_child(state_a)
	state_machine.add_child(state_b)
	state_machine.add_child(state_c)
	
	add_child(state_machine)
	var states = state_machine.states_map
	assert_has(states, "state_a")
	assert_has(states, "state_b")
	assert_has(states, "state_c")