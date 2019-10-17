extends NinePatchRect

onready var label = $Label

var prev_state

func state_changed(new_state: State) -> void:
	match new_state.state_name:
		"crouch":
			label.text = "Back Roll"
		"back roll":
			label.text = "Back Roll"
		"somersault":
			label.text = "Back Roll"
		"jump":
			label.text = "Back Dash"
		"high jump":
			label.text = "Back Dash"
		"fall":
			label.text = "Back Dash"
		"air dash":
			label.text = "Back Dash"
		"air back dash":
			label.text = "Back Dash"
		_:
			if not prev_state in ["jump", "high jump", "air dash", "air back dash"]:
				label.text = "Retreat"
	
	prev_state = new_state.state_name