extends NinePatchRect

onready var label : Label = $Label

var prev_state := ""
var dashed := false

func state_changed(new_state: String) -> void:
	match new_state:
		"crouch":
			label.text = "Somersault"
		"somersault":
			label.text = "Somersault"
		"back roll":
			label.text = "Somersault"
		"jump":
			label.text = "Air Dash"
		"high jump":
			label.text = "Air Dash"
		"fall":
			label.text = "Air Dash"
		"air dash":
			label.text = "Air Dash"
		"air back dash":
			label.text = "Air Dash"
		_:
			if not prev_state in ["jump", "high jump", "air dash", "air back dash"]:
				label.text = "Lunge"
	
	prev_state = new_state