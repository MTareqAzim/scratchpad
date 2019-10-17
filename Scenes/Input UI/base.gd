extends TextureRect

onready var a_text = $ATextBox
onready var b_text = $BTextBox
onready var x_text = $XTextBox
onready var y_text = $YTextBox

func _on_StateMachine_state_changed(states_stack):
	var new_state = states_stack[0]
	
	a_text.state_changed(new_state)
	b_text.state_changed(new_state)
	x_text.state_changed(new_state)
	y_text.state_changed(new_state)
