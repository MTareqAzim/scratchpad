tool
extends Panel

func _ready():
	set_as_toplevel(true)


func _on_ActionBuffer_buffer_changed(buffer_stack):
	var action_names = ''
	var frames = ''
	
	for action in buffer_stack:
		action_names += action + '\n'
		frames += str(buffer_stack[action]) + '\n'
	
	$Actions.text = action_names
	$Frames.text = frames
