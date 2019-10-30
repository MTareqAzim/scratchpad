extends "res://addons/gut/test.gd"

var kinematic_state_component : KinematicStateComponent

func before_each():
	kinematic_state_component = KinematicStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_get_body():
	var doubled_body : KinematicBody2P5D = double(KinematicBody2P5D).new()
	add_child(doubled_body)
	
	kinematic_state_component._body_path = doubled_body.get_path()
	add_child(kinematic_state_component)
	
	assert_eq(kinematic_state_component.body, doubled_body, "Incorrect body.")
	