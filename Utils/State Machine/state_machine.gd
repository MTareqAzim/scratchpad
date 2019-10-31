extends Node
class_name StateMachine, "state_machine.png"

signal state_changed(states_stack)

export (bool) var _active := false setget set_active

var _start_state : Node = null

var states_map : Dictionary = {}
var states_stack : Array = []
var current_state : State = null
var push_down_states : Array = []
var overwrite_states : Array = []


func _ready() -> void:
	_append_states(self)
	_attach_finished_signals()
	initialize()


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _physics_process(delta: float) -> void:
	current_state.update(delta)


func get_class() -> String:
	return "StateMachine"


func is_class(type: String) -> bool:
	return type == "StateMachine" or .is_class(type)


func initialize() -> void:
	set_active(true)
	states_stack.push_front(_start_state)
	current_state = states_stack[0]
	current_state.enter()


func set_active(active: bool) -> void:
	_active = active
	set_physics_process(active)
	set_process_input(active)
	if not _active:
		states_stack = []
		current_state = null


func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _append_states(node: Node) -> void:
	for child in node.get_children():
		if child is State:
			if not _start_state:
				_start_state = child
			states_map[child.state_name] = child
			if child.push_down:
				push_down_states.append(child.state_name)
			if child.overwrite:
				overwrite_states.append(child.state_name)
		
		if child.get_child_count() > 0:
			_append_states(child)


func _attach_finished_signals() -> void:
	for state in states_map.values():
		state.connect("finished", self, "_change_state")


func _change_state(state_name: String) -> void:
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