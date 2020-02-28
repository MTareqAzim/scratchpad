extends NinePatchRect

onready var label : Label = $Label

func state_changed(new_state: String) -> void:
	match new_state:
		_:
			label.text = "Crouch"
