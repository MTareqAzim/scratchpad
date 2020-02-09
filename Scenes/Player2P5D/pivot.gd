extends Position2D


func _on_Look_direction_changed(new_direction: Vector2):
	var isometric_direction : Vector2 = new_direction
	isometric_direction.y = isometric_direction.y / 2
	isometric_direction = isometric_direction.normalized()
	
	set_rotation(isometric_direction.angle())
