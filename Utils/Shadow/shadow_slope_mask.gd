tool
extends ShadowMask
class_name ShadowSlopeMask

export (int) var _height := 0 setget _set_height, get_height
export (int) var _width := 20 setget _set_width
export (int) var _length := 20 setget _set_length
export (int, 0, 315, 45) var _angle := 0 setget _set_angle

onready var _ready : bool = true
onready var _collider : CollisionPolygon2D = $CollisionPolygon2D
onready var _rise : RayCast2D = $Rise



func get_class() -> String:
	return "ShadowSlopeMask"


func is_class(type: String) -> bool:
	return type == "ShadowSlopeMask" or .is_class(type)


func get_top_z_pos(points: Array) -> int:
	var top_z_pos = _z_pos
	var altitude = 0
	
	if _height != 0:
		for point in points:
			point = to_local(point)
			altitude = max(altitude, _get_altitude(point))
		
		var fraction = 1.0 * altitude / float(_length)
		top_z_pos = _z_pos - int(ceil(_height * fraction))
	
	return top_z_pos


#Private getters and setters
func _set_height(new_height: int) -> void:
	_height = new_height
	_update_components()


func get_height() -> int:
	return _height


func _set_width(new_width: int) -> void:
	_width = new_width
	_update_components()


func _set_length(new_length: int) -> void:
	_length = new_length
	_update_components()


func _set_angle(new_angle: int) -> void:
	_angle = new_angle
	_update_components()


#Helper methods
func _get_altitude(pos: Vector2) -> float:
	var br = _base.polygon[2]
	var bl = _base.polygon[3]
	
	var area = Geometry2D.area([br, bl, pos])
	var width = br.distance_to(bl)
	var altitude = 2.0 * area / width
	
	return altitude


#Editor functions
func _update_components() -> void:
	if _ready:
		_update_base()
		_update_collider()
		_update_rise()


func _update_base() -> void:
	var start_point = Vector2(-_width/2.0, -_length/2.0)
	var size = Vector2(_width, _length)
	var rect = Rect2(start_point, size)
	var points = Geometry2D.rect_to_array(rect)
	
	for i in points.size():
		points[i] = Geometry2D.rotate_about_point(points[i], Vector2(), _angle)
	
	_base.set_polygon(points)
	_base.set_position(Vector2())


func _update_collider() -> void:
	_collider.set_polygon(_base.get_polygon())
	_collider.set_position(_base.get_position())


func _update_rise() -> void:
	var start = Geometry2D.rotate_about_point(Vector2(0, _length/2.0), Vector2(), _angle)
	var stop = Geometry2D.rotate_about_point(Vector2(0, -_length), Vector2(), _angle) - Vector2(0, _height)
	
	_rise.set_position(start)
	_rise.set_cast_to(stop)
