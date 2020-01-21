tool
extends Area2D
class_name ShadowMask

const HALF_OPACTIY = Color(1, 1, 1, 0.5)

export (int) var _z_pos := 0 setget _set_z_pos, get_z_pos
export (int) var _height := 0 setget _set_height, get_height
export (int) var _width := 10 setget _set_width
export (int) var _length := 10 setget _set_length
export (int, 0, 315, 45) var _angle := 0 setget _set_angle


onready var _ready : bool = true
onready var _collider : CollisionPolygon2D = $CollisionPolygon2D
onready var _base : CompositePolygon2D = $Base
onready var _rise : RayCast2D = $Rise

var shadows_to_draw : Dictionary = {}


func _draw() -> void:
	for texture in shadows_to_draw:
		var texture_position = shadows_to_draw[texture]
		draw_texture(texture, texture_position, HALF_OPACTIY)


func _physics_process(delta: float) -> void:
	shadows_to_draw.clear()
	update()


func get_class() -> String:
	return "ShadowMask"


func is_class(type: String) -> bool:
	return type == "ShadowMask" or .is_class(type)


func _set_z_pos(new_z_pos: int) -> void:
	var diff = _z_pos - new_z_pos
	_z_pos = new_z_pos
	
	if _ready:
		translate(Vector2(0, -diff))


func get_z_pos() -> int:
	return _z_pos


func get_top_z_pos(points: Array) -> int:
	var altitude = 0
	
	for point in points:
		point = to_local(point)
		altitude = max(altitude, _get_altitude(point))
	
	var fraction = 1.0 * altitude / float(_length)
	return _z_pos - int(ceil(_height * fraction))


func _get_altitude(pos: Vector2) -> float:
	var br = _base.polygon[2]
	var bl = _base.polygon[3]
	
	var area = Geometry2D.area([br, bl, pos])
	var width = br.distance_to(bl)
	var altitude = 2.0 * area / width
	
	return altitude


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


func draw_shadow(shadow: Shadow2D) -> void:
	var texture = shadow.texture
	var position_3d = shadow.get_global_pos()
	var position_2d = Vector2(position_3d.x, position_3d.y + _z_pos)
	var top_z_pos = get_top_z_pos([position_2d])
	var local_position = to_local(position_2d)
	
	for shape in get_base_shapes(_z_pos):
		if Geometry2D.point_in_polygon(local_position, shape):
			shadows_to_draw[texture] = local_position - texture.get_size()/2 + Vector2(0, top_z_pos - _z_pos)
			update()


func get_base_shapes(z_pos: int) -> Array:
	var polygons = []
	
	for polygon in _base.polygons:
		var translated_polygon = []
		for point in polygon:
			translated_polygon.append(point + _base.position)
		
		polygons.append(translated_polygon)
	
	return polygons


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
