extends NinePatchRect

onready var label : Label = $Label

var prev_state := ""
var dashed := false

func state_changed(new_state: String) -> void:
	
	prev_state = new_state
