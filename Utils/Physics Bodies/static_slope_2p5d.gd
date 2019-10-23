tool
extends StaticBody2P5D

const SKIN_WIDTH := 3

export (int) var _z_pos := 0 setget _set_z_pos, get_z_pos
export (int) var _height := 0 setget _set_height, get_height
export (int) var _width := 20 setget _set_width
export (int) var _length := 20 setget _set_length
export (int, 0, 315, 45) var _angle := 0 setget _set_angle

onready var base_shape = $BaseShape
onready var top_shape = $TopShape
onready var volume_shape = $VolumeShape
onready var rise = $Rise
onready var dist_to_ground = $DistToGround

var _first_time = [true, true, true, true, true]


func get_z_pos() -> int:
	return _z_pos


func get_height() -> int:
	return _height


func get_base_shapes(z_pos: int) -> Array:
	var shapes = []
	
	if z_pos <= _z_pos and z_pos >= _z_pos - _height:
		var z_diff = abs(z_pos - _z_pos) * 1.0
		var percent = (1.0 - z_diff / _height) * 100.0
		
		if percent <= 0:
			pass
		elif percent >= 100:
			shapes = [$BaseShape.polygon]
		else:
			shapes = [_get_percent_base(percent)]
	
	return shapes


func get_top_z_pos(points: Array) -> int:
	var altitude = 0
	
	for point in points:
		altitude = max(altitude, _get_altitude(point))
	
	var fraction = 1.0 * altitude / _length
	return _z_pos - int(round(_height * fraction))


func get_base_transform() -> Transform2D:
	return base_shape.get_global_transform()


func _get_altitude(pos: Vector2) -> float:
	pos = to_local(pos)
	var br = base_shape.polygon[2]
	var bl = base_shape.polygon[3]
	
	var area = abs(pos.x * br.y + br.x * bl.y + bl.x * pos.y - br.x * pos.y - bl.x * br.y - pos.x * bl.y) / 2.0
	var width = br.distance_to(bl)
	var altitude = 2.0 * area / width
	
	return altitude


func _get_percent_base(percent: float) -> Array:
	var points = base_shape.polygon
	var dir_vector = points[2] - points[1]
	dir_vector = (dir_vector * percent / 100).round()
	
	var percent_base = [points[0], points[1], points[1] + dir_vector, points[0] + dir_vector]
	
	return percent_base


#Editor functions
func _set_z_pos(new_z: int) -> void:
	var diff = _z_pos - new_z
	_z_pos = new_z
	
	if Engine.is_editor_hint():
		if _first_time[0]:
			_first_time[0] = false
		else:
			translate(Vector2(0, -diff))
			_update_dist_to_ground()


func _set_height(new_height: int) -> void:
	_height = new_height
	
	if Engine.is_editor_hint():
		_update_top()
		_update_volume()
		_update_rise()


func _set_width(new_width: int) -> void:
	_width = new_width

	if Engine.is_editor_hint():
		_update_base()
		_update_top()
		_update_volume()


func _set_length(new_length: int) -> void:
	_length = new_length

	if Engine.is_editor_hint():
		_update_base()
		_update_top()
		_update_volume()
		_update_rise()


func _set_angle(new_angle: int) -> void:
	_angle = new_angle

	if Engine.is_editor_hint():
		_update_base()
		_update_top()
		_update_volume()
		_update_rise()


func _update_base() -> void:
	var extents = Vector2(_width/2.0, _length/2.0)
	
	var top_left = Geometry2D.rotate_about_point(Vector2(-extents.x, -extents.y), Vector2(), _angle)
	var top_right = Geometry2D.rotate_about_point(Vector2(extents.x, -extents.y), Vector2(), _angle)
	var bottom_right = Geometry2D.rotate_about_point(Vector2(extents.x, extents.y), Vector2(), _angle)
	var bottom_left = Geometry2D.rotate_about_point(Vector2(-extents.x, extents.y), Vector2(), _angle)
	
	base_shape.polygon = PoolVector2Array([top_left, top_right, bottom_right, bottom_left])


func _update_top() -> void:
	var top_left = base_shape.polygon[0] - Vector2(0, _height)
	var top_right = base_shape.polygon[1] - Vector2(0, _height)
	var bottom_right = base_shape.polygon[2]
	var bottom_left = base_shape.polygon[3]
	
	top_shape.polygon = PoolVector2Array([top_left, top_right, bottom_right, bottom_left])


func _update_volume() -> void:
	var vector_array = []
	
	if [0, 45, 225, 270, 315].has(_angle):
		vector_array.append(top_shape.polygon[0])
	if [90, 135, 180, 225].has(_angle):
		vector_array.append(base_shape.polygon[0])
	if [135, 180, 225, 270].has(_angle):
		vector_array.append(base_shape.polygon[1])
	if [0, 45, 90, 135, 315].has(_angle):
		vector_array.append(top_shape.polygon[1])
	if [315].has(_angle):
		vector_array.append(base_shape.polygon[1])
	vector_array.append(base_shape.polygon[2])
	vector_array.append(base_shape.polygon[3])
	if [45].has(_angle):
		vector_array.append(base_shape.polygon[0])
	
	volume_shape.polygon = PoolVector2Array(vector_array)


func _update_rise() -> void:
	var start = Geometry2D.rotate_about_point(Vector2(0, _length/2.0), Vector2(), _angle)
	var stop = Geometry2D.rotate_about_point(Vector2(0, -_length), Vector2(), _angle) - Vector2(0, _height)
	
	rise.position = start
	rise.set_cast_to(stop)


func _update_dist_to_ground() -> void:
	dist_to_ground.set_cast_to(Vector2(0, -_z_pos))
	dist_to_ground.visible = dist_to_ground.cast_to != Vector2.ZERO