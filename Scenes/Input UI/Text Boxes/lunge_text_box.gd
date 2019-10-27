extends NinePatchRect

onready var label : Label = $Label
onready var grayed : Sprite = $Grayed

const FONT16 = preload("res://Scenes/Input UI/PixelFont16.tres")
const FONT20 = preload("res://Scenes/Input UI/PixelFont20.tres")

var prev_state := ""
var dashed := false

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
		label.add_font_override("font", FONT16)
	else:
		label.add_font_override("font", FONT20)
	
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