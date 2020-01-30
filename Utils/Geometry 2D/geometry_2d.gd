class_name Geometry2D

static func area(points: Array) -> float:
	return abs(_area(points))


static func centroid(points: Array) -> Vector2:
	var c_x := 0.0
	var c_y := 0.0
	var area := _area(points)
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		c_x += (points[i].x + points[next_i].x) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
		c_y += (points[i].y + points[next_i].y) * ((points[i].x * points[next_i].y) - (points[next_i].x * points[i].y))
	
	c_x = c_x / (6 * area)
	c_y = c_y / (6 * area)
	return Vector2(c_x, c_y)


static func rotate_about_point(point: Vector2, pivot: Vector2, degrees: float) -> Vector2:
	var sin_angle = sin(deg2rad(degrees))
	var cos_angle = cos(deg2rad(degrees))
	
	var rotated_x = cos_angle * (point.x - pivot.x) + \
			sin_angle * (point.y - pivot.y) + pivot.x
	var rotated_y = -sin_angle * (point.x - pivot.x) + \
			cos_angle * (point.y - pivot.y) + pivot.y
	
	return Vector2(rotated_x, rotated_y)


static func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var wn = 0
	
	for i in polygon.size():
		var next_i = (i + 1) % polygon.size()
		if polygon[i].y <= point.y:
			if polygon[next_i].y > point.y:
				var clockwise_value = clockwise(polygon[i], polygon[next_i], point)
				if clockwise_value < 0:
					wn += 1
				if clockwise_value == 0:
					wn = 1
					break
		elif polygon[next_i].y <= point.y:
			var clockwise_value = clockwise(polygon[i], polygon[next_i], point)
			if clockwise_value > 0:
				wn -= 1
			if clockwise_value == 0:
					wn = -1
					break
	
	return wn != 0


static func clockwise(p0: Vector2, p1: Vector2, p2: Vector2) -> float:
	var z = (p1.x - p0.x) * (p2.y - p0.y) - (p1.y - p0.y) * (p2.x - p0.x)
	return z


static func bounding_box(points: Array) -> Rect2:
	var min_x = points[0].x
	var max_x = min_x
	var min_y = points[0].y
	var max_y = min_y
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var size = Vector2(max_x - min_x, max_y - min_y)
	
	return Rect2(Vector2(min_x, min_y), size)


static func rect_to_array(rect: Rect2) -> Array:
	var points = []
	
	if rect.size == Vector2.ZERO:
		points = [rect.position]
	else:
		points = [rect.position,
				rect.position + Vector2(rect.size.x, 0),
				rect.position + rect.size,
				rect.position + Vector2(0, rect.size.y)]
	
	return points


static func point_on_segment_2d(point: Vector2, from: Vector2, to: Vector2, error: Vector2) -> bool:
	var point_on_segment = false
	var closest_point = Geometry.get_closest_point_to_segment_2d(point, from, to)
	if vector_within_error(point.round(), closest_point.round(), error):
		point_on_segment = true
	
	return point_on_segment


static func vector_within_error(point: Vector2, comparison: Vector2, error: Vector2) -> bool:
	var x_within = false
	var y_within = false
	var within_error = false
	
	if point.x <= comparison.x + error.x and point.x >= comparison.x - error.x:
		x_within = true
	
	if point.y <= comparison.y + error.y and point.y >= comparison.y - error.y:
		y_within = true
	
	within_error = x_within and y_within
	return within_error


static func in_front_of(polygon: Array, comparison: Array) -> bool:
	var in_front_of = true
	var error = Vector2(1, 1)
	
	for point in polygon:
		var point_to_inf = point + Vector2(0, 10000)
		var intersection_occured = false
		for comparison_index in comparison.size():
			var comparison_index_next = (comparison_index + 1) % comparison.size()
			var intersection = Geometry.segment_intersects_segment_2d(point, point_to_inf,
									comparison[comparison_index], comparison[comparison_index_next])
			if intersection:
				if not point_on_segment_2d(point, comparison[comparison_index], comparison[comparison_index_next], error):
					intersection_occured = true
		
		if intersection_occured:
			in_front_of = false
			break
	
	if in_front_of:
		for point in comparison:
			var point_to_neg_inf = point + Vector2(0, -10000)
			var intersection_occured = false
			for polygon_index in polygon.size():
				var polygon_index_next = (polygon_index + 1) % polygon.size()
				var intersection = Geometry.segment_intersects_segment_2d(point, point_to_neg_inf,
										polygon[polygon_index], polygon[polygon_index_next])
				if intersection:
					if not point_on_segment_2d(point, polygon[polygon_index], polygon[polygon_index_next], error):
						intersection_occured = true
			
			if intersection_occured:
				in_front_of = false
				break
	
	return in_front_of


static func _area(points: Array) -> float:
	var area := 0.0
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		area += points[i].x * points[next_i].y - points[next_i].x * points[i].y
	
	area = area / 2.0
	return area
