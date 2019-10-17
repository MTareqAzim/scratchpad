extends NinePatchRect

onready var label = $Label

func state_changed(new_state: State) -> void:
	match new_state.state_name:
		_:
			label.text = "Crouch"