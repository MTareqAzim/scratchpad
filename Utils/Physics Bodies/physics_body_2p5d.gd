extends Area2D
class_name PhysicsBody2P5D


func get_class() -> String:
	return "PhysicsBody2P5D"


func is_class(type: String) -> bool:
	return type == "PhysicsBody2P5D" or .is_class(type)


func get_z_pos() -> int:
	return 0


func get_height() -> int:
	return 0


func get_base_shapes(z_pos: int) -> Array:
	return []


func get_base_transform() -> Transform2D:
	return Transform2D()


func get_top_z_pos(points: Array) -> int:
	return 0


func get_global_pos() -> Vector3:
	return Vector3()


func in_front_of(body: Node2D) -> bool:
	var in_front_of := false
	var above = false
	var below = false
	
	if body.is_class("PhysicsBody2P5D"):
		var other_z_pos = body.get_z_pos()
		var lowest_common_z_pos = 0
		if other_z_pos > get_z_pos():
			lowest_common_z_pos = get_z_pos()
			var position_2d = Vector2(get_global_pos().x, get_global_pos().y + get_z_pos())
			if lowest_common_z_pos <= body.get_top_z_pos([position_2d]):
				above = true
		else:
			lowest_common_z_pos = other_z_pos
			var position_2d = Vector2(body.get_global_pos().x, body.get_global_pos().y + body.get_z_pos())
			if lowest_common_z_pos <= get_top_z_pos([position_2d]):
				below = true
		
		var depth_slice = []
		var other_depth_slice = []
		if above:
			other_depth_slice = body.get_depth_slice(body.get_top_z_pos([global_position]))
		elif below:
			depth_slice = get_depth_slice(get_top_z_pos([global_position]))
		
		if depth_slice == []:
			depth_slice = get_depth_slice(lowest_common_z_pos)
		if other_depth_slice == []:
			other_depth_slice = body.get_depth_slice(lowest_common_z_pos)
		
		if depth_slice:
			if other_depth_slice:
				in_front_of = Geometry2D.in_front_of(depth_slice, other_depth_slice)
			else:
				in_front_of = true
		else:
			in_front_of = false
		
		if above:
			var collision_points = Collision2D.collide_and_get_contacts(depth_slice, Transform2D(), other_depth_slice, Transform2D())
			if collision_points.size() > 2:
				in_front_of = true
		if below:
			var collision_points = Collision2D.collide_and_get_contacts(depth_slice, Transform2D(), other_depth_slice, Transform2D())
			if collision_points.size() > 2:
				in_front_of = false
	else:
		in_front_of = get_global_pos().y > body.global_position.y
	
	return in_front_of


func get_depth_slice(z_pos: int) -> Array:
	var slice = []
	
	if z_pos <= get_z_pos() or z_pos >= get_z_pos() - get_height():
		var base_shapes = get_base_shapes(z_pos)
		for shape in base_shapes:
			for point in shape:
				if not slice.has(point):
					slice.append(point)
	
	if slice:
		var base_transform = get_base_transform()
		for index in slice.size():
			slice[index] = base_transform.xform(slice[index])
		if not z_pos == get_z_pos():
			for index in slice.size():
				slice[index] = slice[index] + Vector2(0, z_pos - get_z_pos())
		slice = Collision2D._sort_points_clockwise(slice)
	
	
	return slice