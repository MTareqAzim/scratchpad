extends Position2D

func _on_Look_Direction_direction_changed(new_direction):
	rotation = new_direction.angle()
