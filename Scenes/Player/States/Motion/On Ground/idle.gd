extends "on_ground.gd"

func update(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction != Vector2.ZERO:
		emit_signal("finished", "move")
	
	.update(delta)
