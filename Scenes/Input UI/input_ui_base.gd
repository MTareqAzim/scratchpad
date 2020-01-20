extends TextureRect

onready var a_text = $ATextBox
onready var b_text = $BTextBox
onready var x_text = $XTextBox
onready var y_text = $YTextBox

func _on_State_Machine_state_changed(state_name):
	a_text.call_deferred("state_changed", state_name)
	b_text.call_deferred("state_changed", state_name)
	x_text.call_deferred("state_changed", state_name)
	y_text.call_deferred("state_changed", state_name)
