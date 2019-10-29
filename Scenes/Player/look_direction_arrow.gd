extends Position2D

func _physics_process(delta: float) -> void:
	rotation = owner.get_look_direction().angle()
