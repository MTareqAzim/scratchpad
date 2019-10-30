extends "res://addons/gut/test.gd"

var not_equals_component : NotEqualsTransitionKinematicStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D


func before_each():
	not_equals_component = NotEqualsTransitionKinematicStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(not_equals_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	not_equals_component.body = doubled_body
	not_equals_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_not_equals_transition():
	stub(doubled_body, "get_velocity").to_return("pass")
	
	not_equals_component.FUNCTION_NAME = "get_velocity"
	not_equals_component.NEXT_STATE = "next_state"
	not_equals_component.not_equals = "not equals"
	
	not_equals_component.update(0.1)
	assert_called(doubled_state, "finished", ["next_state"])

func test_equals_no_transition():
	stub(doubled_body, "get_velocity").to_return("equals")

	not_equals_component.FUNCTION_NAME = "get_velocity"
	not_equals_component.NEXT_STATE = "next_state"
	not_equals_component.not_equals = "equals"
	
	not_equals_component.update(0.1)
	assert_not_called(doubled_state, "finished", ["next_state"])