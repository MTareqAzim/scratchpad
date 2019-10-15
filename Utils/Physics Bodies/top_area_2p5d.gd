extends Area2D

func get_z_pos() -> int:
	return get_parent().get_z_pos()


func get_height() -> int:
	return get_parent().get_height()


func get_top_z_pos(points: Array) -> int:
	return get_z_pos() - get_height()


func get_top_shapes() -> Array:
	var shapes = []
	
	for owner in get_shape_owners():
		for shape_id in shape_owner_get_shape_count(owner):
			shapes.append(shape_owner_get_shape(owner, shape_id))
	
	return shapes


func get_top_transform() -> Transform2D:
	return $TopShape.get_global_transform()