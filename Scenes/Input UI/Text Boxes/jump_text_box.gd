extends NinePatchRect

onready var label : Label = $Label

var latest_jump := "jump"
var prev_state := ""

func set_text(new_text: String) -> void:
	label.text = new_text


func state_changed(new_state: String) -> void:
	match new_state:
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
	
	if new_state in ["jump", "high jump"]:
		latest_jump = new_state
	
	prev_state = new_state
