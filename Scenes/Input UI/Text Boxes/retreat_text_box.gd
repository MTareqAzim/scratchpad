extends NinePatchRect

onready var label : Label = $Label
onready var grayed : Sprite = $Grayed

var prev_state := ""
var dashed := false

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
	
	if dashed:
		grayed.visible = true
	elif new_state.state_name in ["back roll", "air back dash", "somersault", "air dash", "lunge", "retreat"]:
		grayed.visible = true
	else:
		grayed.visible = false
	
	if new_state.state_name in ["air dash", "air back dash"]:
		dashed = true
	
	if new_state.state_name == "fall":
		dashed = false
	
	prev_state = new_state.state_name