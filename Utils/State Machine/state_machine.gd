extends Node
class_name StateMachine, "state_machine.png"

export (NodePath) var START_STATE

var states_map = {}
var states_stack := []
var current_state = null

var _active := false setget set_active


func _ready():
	_attach_finished_signals(self)
	initialize(START_STATE)


func _attach_finished_signals(node: Node) -> void:
	for child in node.get_children():
		if child is State:
			child.connect("finished", self, "_change_state")
		if child.get_child_count() > 0:
			_attach_finished_signals(child)


func initialize(start_state: NodePath) -> void:
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(active: bool) -> void:
	_active = active
	set_physics_process(active)
	set_process_input(active)
	if not _active:
		states_stack = []
		current_state = null


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)


func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	
	if state_name != "previous":
		current_state.enter()