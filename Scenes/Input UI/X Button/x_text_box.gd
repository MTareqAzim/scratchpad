extends NinePatchRect

onready var label = $Label

const font16 = preload("res://Scenes/Input UI/PixelFont16.tres")
const font20 = preload("res://Scenes/Input UI/PixelFont20.tres")

var prev_state

func state_changed(new_state: State) -> void:
	match new_state.state_name:
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
	
	if new_state.state_name in ["crouch", "somersault", "back roll"]:
		label.add_font_override("font", font16)
	else:
		label.add_font_override("font", font20)
	
	prev_state = new_state.state_name