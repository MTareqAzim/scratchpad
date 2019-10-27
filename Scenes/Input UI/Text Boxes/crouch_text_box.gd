extends NinePatchRect

onready var label : Label = $Label
onready var grayed : Sprite = $Grayed
onready var greened : Sprite = $Greened

func state_changed(new_state: State) -> void:
	match new_state.state_name:
		_:
			label.text = "Crouch"
	
	if new_state.state_name in ["idle", "move", "crouch"]:
		grayed.visible = false
	else:
		grayed.visible = true
	
	greened.visible = new_state.state_name == "crouch"