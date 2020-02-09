extends Area2D
class_name DepthSort

const ALPHA_SEVENTY_FIVE = Color(1, 1, 1, 0.75)

export (NodePath) var body

onready var _body : Node2D = get_node(body) setget _set_body, get_body


func get_body() -> Node2D:
	return _body


func set_body_z_index(new_z_index: int) -> void:
	_body.set_z_index(new_z_index)


func get_overlapping_depth_sorts() -> Array:
	return get_overlapping_areas()


func in_front_of(depth_sort: DepthSort) -> bool:
	var in_front_of = false
	
	if _body is PhysicsBody2P5D:
		in_front_of = _in_front_of(depth_sort)
	else:
		var body_y_position = _body.global_position.y
		var other_y_position = depth_sort.get_body().global_position.y
		in_front_of = body_y_position > other_y_position
	
	return in_front_of


func get_depth_slice(z_pos: int) -> Array:
	var slice = []
	
	if z_pos <= _body.get_z_pos() and z_pos >= _body.get_z_pos() - _body.get_height():
		var base_shapes = _body.get_base_shapes(z_pos)
		for shape in base_shapes:
			for point in shape:
				if not slice.has(point):
					slice.append(point)
	
	if slice:
		var base_transform = _body.get_base_transform()
		for index in slice.size():
			slice[index] = base_transform.xform(slice[index])
		if not z_pos == _body.get_z_pos():
			for index in slice.size():
				slice[index] = slice[index] + Vector2(0, z_pos - _body.get_z_pos())
		slice = Collision2D._sort_points_clockwise(slice)
	
	
	return slice


func _set_body(new_body: Node2D) -> void:
	_body = new_body


func _in_front_of(other_depth_sort: Area2D) -> bool:
	var other_body = other_depth_sort.get_body()
	var in_front_of := false
	var above = false
	var below = false
	
	if other_body is PhysicsBody2P5D:
		var other_z_pos = other_body.get_z_pos()
		var lowest_common_z_pos = 0
		if other_z_pos > _body.get_z_pos():
			lowest_common_z_pos = _body.get_z_pos()
			var body_global_pos = _body.get_global_pos()
			var position_2d = Vector2(body_global_pos.x, body_global_pos.y + body_global_pos.z)
			if lowest_common_z_pos <= other_body.get_top_z_pos([position_2d]):
				above = true
		else:
			lowest_common_z_pos = other_z_pos
			var position_2d = Vector2(other_body.get_global_pos().x, other_body.get_global_pos().y + other_body.get_z_pos())
			if lowest_common_z_pos <= _body.get_top_z_pos([position_2d]):
				below = true
		
		var depth_slice = get_depth_slice(lowest_common_z_pos)
		var other_depth_slice = other_depth_sort.get_depth_slice(lowest_common_z_pos)
		
		if above and other_depth_slice != []:
			other_depth_slice = other_depth_sort.get_depth_slice(other_body.get_top_z_pos([_body.global_position]))
		
		if below and depth_slice != []:
			var top_z_pos = _body.get_top_z_pos([other_body.global_position])
			depth_slice = get_depth_slice(top_z_pos)
		
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
		in_front_of = _body.get_global_pos().y > other_body.global_position.y
	
	return in_front_of
