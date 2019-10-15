extends CollisionShape2D

func _physics_process(delta):
	position = Vector2(0, -get_parent().get_z_pos())
