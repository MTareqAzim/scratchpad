extends "../motion.gd"

func update(delta) -> void:
	if owner.is_grounded():
		emit_signal("finished", "previous")
	.update(delta)


func handle_input(event) -> void:
	if event.is_action("ui_a"):
		get_tree().set_input_as_handled()
		if event.is_action_pressed("ui_a"):
			action_buffer.add_event("ui_a_pressed")
	
	.handle_input(event)