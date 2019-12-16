extends TextureRect

onready var a_text = $ATextBox
onready var b_text = $BTextBox
onready var x_text = $XTextBox
onready var y_text = $YTextBox

func _on_State_Machine_state_changed(states_stack):
	var new_state = states_stack[0]
	
	a_text.call_deferred("state_changed", new_state)
	b_text.call_deferred("state_changed", new_state)
	x_text.call_deferred("state_changed", new_state)
	y_text.call_deferred("state_changed", new_state)
