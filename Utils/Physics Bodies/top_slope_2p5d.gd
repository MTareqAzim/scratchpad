extends "top_area_2p5d.gd"


func get_top_z_pos(points: Array) -> int:
	var fraction = 0.0
	
	for point in points:
		fraction = max(fraction, _get_fraction(point))
	
	return get_z_pos() - int(ceil(get_height() * fraction))


func _get_fraction(point: Vector2) -> float:
	point = to_local(point)
	var tr = $TopShape.polygon[1]
	var br = $TopShape.polygon[2]
	var bl = $TopShape.polygon[3]
	
	var neg_slope = br - tr
	var intersect = Geometry.segment_intersects_segment_2d(br, bl, point, point + neg_slope * 2)
	var base_to_point = Vector2()
	if intersect:
		base_to_point = point - intersect
	var fraction = base_to_point.length() / neg_slope.length()
	
	return fraction