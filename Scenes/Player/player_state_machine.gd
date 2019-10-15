extends StateMachine

signal state_changed(states_stack)

var push_down_states : Array = []
var overwrite_states : Array = []

func _ready():
	_append_states(self)


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


func _change_state(state_name):
	if not _active:
		return
	
	if state_name in overwrite_states:
		if states_stack.size() > 1:
			states_stack.pop_front()
	
	if state_name in push_down_states:
		states_stack.push_front(states_map[state_name])
	
	._change_state(state_name)
	
	emit_signal("state_changed", states_stack)
