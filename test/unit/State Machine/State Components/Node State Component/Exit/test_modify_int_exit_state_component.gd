extends "res://addons/gut/test.gd"

var modify_int_component : ModifyIntExitStateComponent
var doubled_state : ComponentState
var doubled_body : KinematicBody2P5D

func before_each():
	modify_int_component = ModifyIntExitStateComponent.new()
	doubled_state = double(ComponentState).new()
	doubled_body = double(KinematicBody2P5D).new()
	
	doubled_state.add_child(modify_int_component)
	add_child(doubled_body)
	add_child(doubled_state)
	
	modify_int_component.node = doubled_body
	modify_int_component.component_state = doubled_state

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_modify_int_exit():
	modify_int_component.FUNCTION_NAME = "set_grav"
	modify_int_component.new_value = 100
	
	modify_int_component.exit()
	assert_called(doubled_body, "set_grav", [100])