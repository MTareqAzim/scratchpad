extends "res://addons/gut/test.gd"

var greater_than_component : GreaterThanTransitionStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	greater_than_component = GreaterThanTransitionStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(greater_than_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	greater_than_component.node = doubled_body
	greater_than_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_greater_than_transition():
	stub(doubled_body, "get_velocity").to_return(7.0)
	
	greater_than_component.FUNCTION_NAME = "get_velocity"
	greater_than_component.NEXT_STATE = "next_state"
	greater_than_component.greater_than = 5.0
	
	greater_than_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_less_than_no_transition():
	stub(doubled_body, "get_velocity").to_return(0.0)
	
	greater_than_component.FUNCTION_NAME = "get_velocity"
	greater_than_component.NEXT_STATE = "next_state"
	greater_than_component.greater_than = 2.0
	
	greater_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])

func test_equals_no_transition():
	stub(doubled_body, "get_velocity").to_return(3.0)
	
	greater_than_component.FUNCTION_NAME = "get_velocity"
	greater_than_component.NEXT_STATE = "next_state"
	greater_than_component.greater_than = 3.0
	
	greater_than_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])