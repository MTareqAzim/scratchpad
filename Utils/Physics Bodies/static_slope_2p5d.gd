tool
extends StaticBody2P5D
class_name StaticSlope2P5D, "static_slope_2p5d.png"

onready var _base_shape = $BaseShape
onready var _top_shape = $TopShape
onready var _volume_shape = $VolumeShape
onready var _rise = $Rise
onready var _dist_to_ground = $DistToGround
onready var _ready := true

const SKIN_WIDTH := 3

export (int) var _z_pos := 0 setget _set_z_pos, get_z_pos
export (int) var _height := 0 setget _set_height, get_height
export (int) var _width := 20 setget _set_width
export (int) var _length := 20 setget _set_length
export (int, 0, 315, 45) var _angle := 0 setget _set_angle


func get_class() -> String:
	return "StaticSlope2P5D"


func is_class(type: String) -> bool:
	return type == "StaticSlope2P5D" or .is_class(type)


func get_global_pos() -> Vector3:
	return Vector3(global_position.x, global_position.y - _z_pos, _z_pos)


func get_z_pos() -> int:
	return _z_pos


func get_height() -> int:
	return _height


func get_base_shapes(z_pos: int) -> Array:
	var shapes = []
	
	if z_pos <= _z_pos and z_pos >= _z_pos - _height:
		var z_diff = abs(z_pos - _z_pos) * 1.0
		var percent
		if _height == 0:
			percent = 100
		else:
			percent = (1.0 - z_diff / _height) * 100.0
		
		if percent <= 0:
			shapes = []
		elif percent >= 100:
			shapes = [$BaseShape.polygon]
		else:
			shapes = [_get_percent_base(percent)]
	
	return shapes


func get_top_z_pos(points: Array) -> int:
	var altitude = 0
	
	for point in points:
		point = to_local(point)
		altitude = max(altitude, _get_altitude(point))
	
	var fraction = 1.0 * altitude / float(_length)
	if fraction > 1.0:
		fraction = 1.0
	return _z_pos - int(ceil(_height * fraction))


func get_base_transform() -> Transform2D:
	return _base_shape.get_global_transform()


func in_front_of(body: Node2D) -> bool:
	var in_front_of := false
	
	if body is PhysicsBody2P5D:
		in_front_of = get_back_y_pos() > body.get_back_y_pos(get_global_pos())
	else:
		in_front_of = get_back_y_pos() > body.global_position.y
	
	return in_front_of


func get_back_y_pos(global_pos: Vector3 = Vector3.INF) -> int:
	var furthest_y_pos = 0
	var position_2d = Vector2(global_pos.x, global_pos.y)
	
	var base_points : Array
	base_points = _base_shape.get_polygon()
	for index in base_points.size():
		base_points[index] = base_points[index] + _base_shape.global_position
	
	if global_pos != Vector3.INF and Geometry2D.point_in_polygon(position_2d, base_points):
		var top_z_pos = get_top_z_pos([position_2d])
		var base_shapes = get_base_shapes(top_z_pos)
		if base_shapes:
			base_points = base_shapes[0]
			for index in base_points.size():
				base_points[index] = get_base_transform().xform(base_points[index])
	
	var bounding_box : Rect2 = Geometry2D.bounding_box(base_points)
	
	furthest_y_pos = int(round(bounding_box.position.y))
	
	var visual_position_2d = Vector2(global_pos.x, global_pos.y + global_pos.z)
	
	if _angle in [45, 135, 225, 315]:
		if global_pos != Vector3.INF:
			if global_pos.z > _z_pos + get_top_z_pos([position_2d]):
				if global_pos.y > furthest_y_pos:
					var smallest_y_point = base_points[0]
					for point in base_points:
						if point.y < smallest_y_point.y:
							smallest_y_point = point
					
					var largest_y_point = base_points[0]
					for point in base_points:
						if point.y > largest_y_point.y:
							largest_y_point = point
					
					var closest_point = Geometry.get_closest_point_to_segment_2d(visual_position_2d, smallest_y_point, largest_y_point)
					if global_pos.x < closest_point.x:
						var left_most_point = base_points[0]
						for point in base_points:
							if point.x < left_most_point.x:
								left_most_point = point
						furthest_y_pos = int(round(left_most_point.y))
					else:
						var right_most_point = base_points[0]
						for point in base_points:
							if point.x > right_most_point.x:
								right_most_point = point
						furthest_y_pos = int(round(right_most_point.y))
	
	return furthest_y_pos


func _get_altitude(pos: Vector2) -> float:
	var br = _base_shape.polygon[2]
	var bl = _base_shape.polygon[3]
	
	var area = Geometry2D.area([br, bl, pos])
	var width = br.distance_to(bl)
	var altitude = 2.0 * area / width
	
	return altitude


func _get_percent_base(percent: float) -> Array:
	var points = _base_shape.polygon
	var dir_vector = points[2] - points[1]
	dir_vector = (dir_vector * percent / 100).round()
	
	var percent_base = [points[0], points[1], points[1] + dir_vector, points[0] + dir_vector]
	
	return percent_base


#Editor functions
func _set_z_pos(new_z: int) -> void:
	var diff = _z_pos - new_z
	_z_pos = new_z
	
	if _ready:
		translate(Vector2(0, -diff))
		_update_dist_to_ground()


func _set_height(new_height: int) -> void:
	_height = new_height
	_update_components()


func _set_width(new_width: int) -> void:
	_width = new_width
	_update_components()


func _set_length(new_length: int) -> void:
	_length = new_length
	_update_components()


func _set_angle(new_angle: int) -> void:
	_angle = new_angle
	_update_components()


func _update_components() -> void:
	if not _ready:
		return
	
	_update_base()
	_update_top()
	_update_volume()
	_update_rise()


func _update_base() -> void:
	var start_point = Vector2(-_width/2.0, -_length/2.0)
	var size = Vector2(_width, _length)
	var rect = Rect2(start_point, size)
	var points = Geometry2D.rect_to_array(rect)
	
	for i in points.size():
		points[i] = Geometry2D.rotate_about_point(points[i], Vector2(), _angle)
	
	_base_shape.set_polygon(points)


func _update_top() -> void:
	var points = _base_shape.get_polygon()
	points[0] += Vector2(0, -_height)
	points[1] += Vector2(0, -_height)
	
	_top_shape.set_polygon(points)


func _update_volume() -> void:
	var vector_array = []
	
	if [0, 45, 225, 270, 315].has(_angle):
		vector_array.append(_top_shape.polygon[0])
	if [90, 135, 180, 225].has(_angle):
		vector_array.append(_base_shape.polygon[0])
	if [135, 180, 225, 270].has(_angle):
		vector_array.append(_base_shape.polygon[1])
	if [0, 45, 90, 135, 315].has(_angle):
		vector_array.append(_top_shape.polygon[1])
	if [315].has(_angle):
		vector_array.append(_base_shape.polygon[1])
	vector_array.append(_base_shape.polygon[2])
	vector_array.append(_base_shape.polygon[3])
	if [45].has(_angle):
		vector_array.append(_base_shape.polygon[0])
	
	_volume_shape.set_polygon(vector_array)


func _update_rise() -> void:
	var start = Geometry2D.rotate_about_point(Vector2(0, _length/2.0), Vector2(), _angle)
	var stop = Geometry2D.rotate_about_point(Vector2(0, -_length), Vector2(), _angle) - Vector2(0, _height)
	
	_rise.set_position(start)
	_rise.set_cast_to(stop)


func _update_dist_to_ground() -> void:
	_dist_to_ground.set_cast_to(Vector2(0, -_z_pos))
	_dist_to_ground.set_visible(_dist_to_ground.cast_to != Vector2.ZERO)