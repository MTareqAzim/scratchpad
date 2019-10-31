extends "res://addons/gut/test.gd"

var node_state_component : NodeStateComponent

func before_each():
	node_state_component = NodeStateComponent.new()

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass

func test_get_body():
	var node : Node = Node.new()
	add_child(node)
	
	node_state_component.node_path = node.get_path()
	add_child(node_state_component)
	
	assert_eq(node_state_component.node, node, "Incorrect node.")
	