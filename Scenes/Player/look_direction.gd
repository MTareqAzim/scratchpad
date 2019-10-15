extends Position2D

func _physics_process(delta):
	rotation = owner.get_look_direction().angle()
