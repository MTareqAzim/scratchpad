extends NinePatchRect

onready var label = $Label
var latest_jump := ""
var prev_state

func state_changed(new_state: State) -> void:
	match new_state.state_name:
		"crouch":
			label.text = "High Jump"
		"high jump":
			label.text = "High Jump"
		"fall":
			if latest_jump == "jump":
				label.text = "Jump"
			else:
				label.text = "High Jump"
		"air dash":
			if latest_jump == "jump":
				label.text = "Jump"
			else:
				label.text = "High Jump"
		"air back dash":
			if latest_jump == "jump":
				label.text = "Jump"
			else:
				label.text = "High Jump"
		_:
			if not prev_state in ["jump", "high jump", "air dash", "air back dash"]:
				label.text = "Jump"
	
	if new_state.state_name in ["jump", "high jump"]:
		latest_jump = new_state.state_name
	
	prev_state = new_state.state_name
