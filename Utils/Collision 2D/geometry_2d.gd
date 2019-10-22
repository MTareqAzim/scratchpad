class_name Geometry2D

static func area(points: Array) -> float:
	return abs(_area(points))


static func _area(points: Array) -> float:
	var area := 0.0
	
	for i in points.size():
		var next_i = (i + 1) % points.size()
		area += points[i].x * points[next_i].y - points[next_i].x * points[i].y
	
	area = area / 2.0
	return area


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


static func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var wn = 0
	
	for i in polygon.size():
		var next_i = (i + 1) % polygon.size()
		if polygon[i].y <= point.y:
			if polygon[next_i].y > point.y:
				if clockwise(polygon[i], polygon[next_i], point) < 0:
					wn += 1
				if clockwise(polygon[i], polygon[next_i], point) == 0:
					wn = 1
					break
		elif polygon[next_i].y <= point.y:
			if clockwise(polygon[i], polygon[next_i], point) > 0:
				wn -= 1
			if clockwise(polygon[i], polygon[next_i], point) == 0:
					wn = -1
					break
	
	return wn != 0


static func clockwise(p0: Vector2, p1: Vector2, p2: Vector2) -> float:
	var z = (p1.x - p0.x) * (p2.y - p0.y) - (p1.y - p0.y) * (p2.x - p0.x)
	return z
