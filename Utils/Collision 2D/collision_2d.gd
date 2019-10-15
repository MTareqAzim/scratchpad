static func area(points: Array) -> float:
	var area := 0.0
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		area += points[i].x * points[next_i].y - points[next_i].x * points[i].y
	
	area = area / 2.0
	return area


static func centroid(points: Array) -> Vector2:
	var c_x := 0.0
	var c_y := 0.0
	var area := area(points)
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		c_x += (points[i].x + points[next_i].x) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
		c_y += (points[i].y + points[next_i].y) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
	
	c_x = c_x / (6 * area)
	c_y = c_y / (6 * area)
	return Vector2(c_x, c_y)


static func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var wn = 0
	
	for i in polygon.size():
		var next_i = (i + 1) % polygon.size()
		if polygon[i].y <= point.y:
			if polygon[next_i].y > point.y:
				if _clockwise(polygon[i], polygon[next_i], point) < 0:
					wn += 1
		elif polygon[next_i].y <= point.y:
			if _clockwise(polygon[i], polygon[next_i], point) > 0:
				wn -= 1
	
	return wn != 0


static func collide_and_get_contacts(shape: Shape2D, global_xform: Transform2D, other_shape: Shape2D, other_global_xform: Transform2D) -> Array:
	return collide_with_motion_and_get_contacts(shape, global_xform, Vector2(), other_shape, other_global_xform, Vector2())


static func collide_with_motion_and_get_contacts(shape: Shape2D, global_xform: Transform2D, motion: Vector2,
		other_shape: Shape2D, other_global_xform: Transform2D, other_motion: Vector2) -> Array:
	var collision_points = []

	var shape_points = _get_points(shape)
	for i in shape_points.size():
		shape_points[i] = global_xform.xform(shape_points[i]) + motion
	
	var other_shape_points = _get_points(other_shape)
	for i in other_shape_points.size():
		other_shape_points[i] = other_global_xform.xform(other_shape_points[i]) + other_motion
	
	if shape_points and other_shape_points:
		#other triangles
		for point in shape_points:
			if point_in_polygon(point, other_shape_points):
				if not collision_points.has(point):
					collision_points.append(point)
		
		#shape triangles
		for point in other_shape_points:
			if point_in_polygon(point, shape_points):
				if not collision_points.has(point):
					collision_points.append(point)
		
		#check line intersections
		for i in shape_points.size():
			var next_i = (i + 1) % shape_points.size()
			for j in other_shape_points.size():
				var next_j = (j + 1) % other_shape_points.size()
				var intersection_point = Geometry.segment_intersects_segment_2d(shape_points[i], shape_points[next_i],
						other_shape_points[j], other_shape_points[next_j])
				if intersection_point:
					collision_points.append(intersection_point)
	
	if collision_points:
		collision_points = _sort_points_clockwise(collision_points)
	
	return collision_points


static func collide_and_get_resolution_vector(shape: Shape2D, global_xform: Transform2D, other_shape: Shape2D, other_global_xform: Transform2D) -> Vector2:
	return collide_with_motion_and_get_resolution_vector(shape, global_xform, Vector2(), other_shape, other_global_xform, Vector2())


static func collide_with_motion_and_get_resolution_vector(shape: Shape2D, global_xform: Transform2D, motion: Vector2,
		other_shape: Shape2D, other_global_xform: Transform2D, other_motion: Vector2) -> Vector2:
	var shape_points = _get_points(shape)
	var other_shape_points = _get_points(other_shape)
	
	for i in shape_points.size():
		shape_points[i] = global_xform.xform(shape_points[i]) + motion
	
	for i in other_shape_points.size():
		other_shape_points[i] = other_global_xform.xform(other_shape_points[i]) + other_motion
	
	return resolution_vector(shape_points, other_shape_points, motion)


static func resolution_vector(p: Array, q: Array, p_motion = Vector2()) -> Vector2:
	var neg_p := []
	for point in p:
		 neg_p.append(Vector2(-point.x, -point.y))
	
	var minkowski_sum = _minkowski_sum(neg_p, q)
	var origin = Vector2()
	
	var resolution_vectors = _get_vectors_to_perimeter(origin, minkowski_sum)
	resolution_vectors.sort_custom(CustomSort, "sort_by_length")
	
	var res_vec = Vector2()
	for vector in resolution_vectors:
		if vector == Vector2.ZERO or p_motion.dot(vector) != 0:
			res_vec = vector
			break
	
	return res_vec


static func _clockwise(p0: Vector2, p1: Vector2, p2: Vector2) -> float:
	var z = (p1.x - p0.x) * (p2.y - p0.y) - (p1.y - p0.y) * (p2.x - p0.x)
	return z


static func _get_points(shape: Shape2D) -> Array:
	var points = []
	
	if shape is RectangleShape2D:
		var extents = shape.extents
		points = [Vector2(-extents.x, -extents.y), 
				Vector2(extents.x, -extents.y), 
				Vector2(extents.x, extents.y), 
				Vector2(-extents.x, extents.y)]
	elif shape is ConvexPolygonShape2D:
		points = shape.points
	
	return points


static func _sort_points_clockwise(points: Array) -> Array:
	var p_0: Vector2 = points[0]
	for p_n in points:
		if p_n.y < p_0.y or (p_n.y == p_0.y and p_n.x < p_0.x):
			p_0 = p_n
	
	var sort_points = [[p_0, INF]]
	for p_n in points:
		if p_n != p_0:
			sort_points.append([p_n, abs(p_0.angle_to_point(p_n))])
	sort_points.sort_custom(CustomSort, "sort_by_angle")
	
	var sorted_points = []
	for point in sort_points:
		sorted_points.append(point[0])
	
	return sorted_points


static func _minkowski_sum(p: PoolVector2Array, q: PoolVector2Array) -> PoolVector2Array:
		var m_sum := PoolVector2Array()
		
		for p_n in p:
			for q_n in q:
				m_sum.append(p_n + q_n)
		
		return _convex_hull(m_sum)


static func _convex_hull(p: PoolVector2Array) -> PoolVector2Array:
	var convex_hull: Array = []
	
	var points = _sort_points_clockwise(p)
	
	for point in points:
		while convex_hull.size() > 1 and _clockwise(convex_hull[convex_hull.size() - 2], convex_hull[convex_hull.size() - 1], point) <= 0:
			convex_hull.pop_back()
		convex_hull.append(point)
	
	if convex_hull.size() > 1 and _clockwise(convex_hull[convex_hull.size() - 2], convex_hull[convex_hull.size() - 1], convex_hull[0]) <= 0:
		convex_hull.pop_back()
	
	return PoolVector2Array(convex_hull)


static func _get_vectors_to_perimeter(point: Vector2, polygon: Array) -> Vector2:
	var vectors = []
	
	if point_in_polygon(point, polygon):
		for i in polygon.size():
			var s1 = polygon[i]
			var s2 = polygon[(i + 1) % polygon.size()]
			var closest_point = Geometry.get_closest_point_to_segment_2d(point, s1, s2)
			var vector_to_perimeter: Vector2 = closest_point - point
			vectors.append(vector_to_perimeter)
	
	return vectors


class CustomSort:
	static func sort_by_angle(a: Array, b: Array) -> bool:
		if a[1] > b[1]:
			return true
		elif a[1] == b[1]:
			if a[0].y == b[0].y:
				if a[0].x < b[0].x:
					return true
		return false
	
	static func sort_by_length(a: Vector2, b: Vector2) -> bool:
		if a.length_squared() < b.length_squared():
			return true
		
		return false