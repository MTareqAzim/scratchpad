extends Node
class_name StateMachine, "state_machine.png"

signal state_changed(states_stack)

export (NodePath) var START_STATE

var states_map : Dictionary = {}
var states_stack : Array = []
var current_state : State = null
var push_down_states : Array = []
var overwrite_states : Array = []

var _active := false setget set_active


func _ready() -> void:
	_attach_finished_signals(self)
	initialize(START_STATE)
	_append_states(self)


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


func _append_states(node: Node) -> void:
	for child in node.get_children():
		if child is State:
			states_map[child.state_name] = child
			if child.push_down:
				push_down_states.append(child.state_name)
			if child.overwrite:
				overwrite_states.append(child.state_name)
		
		if child.get_child_count() > 0:
			_append_states(child)


func _unhandled_input(event):
	current_state.handle_input(event)

func handle_input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)


func _change_state(state_name):
	if not _active:
		return
	
	if state_name in overwrite_states:
		if states_stack.size() > 1:
			states_stack.pop_front()
	
	if state_name in push_down_states:
		states_stack.push_front(states_map[state_name])
	
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", states_stack)
	
	if state_name != "previous":
		current_state.enter()