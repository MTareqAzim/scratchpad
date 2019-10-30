extends "res://addons/gut/test.gd"

var equals_component : EqualsTransitionKinematicStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	equals_component = EqualsTransitionKinematicStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(equals_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	equals_component.body = doubled_body
	equals_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_equals_transition():
	stub(doubled_body, "get_velocity").to_return("equals")
	
	equals_component.FUNCTION_NAME = "get_velocity"
	equals_component.NEXT_STATE = "next_state"
	equals_component.equals = "equals"
	
	equals_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_not_equals_no_transition():
	stub(doubled_body, "get_velocity").to_return("not equals")
	
	equals_component.FUNCTION_NAME = "get_velocity"
	equals_component.NEXT_STATE = "next_state"
	equals_component.equals = "equals"
	
	equals_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])