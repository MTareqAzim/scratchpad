tool
extends Area2D
class_name ShadowMask

const SHADOW_OPACTIY = Color(1, 1, 1, 0.5)
const MAX_DISTANCE_FROM_SHADOW = 100
const MIN_FRACTION_SIZE = 0.75

export (int) var _z_pos := 0 setget _set_z_pos, get_z_pos
export (int) var _height := 0 setget _set_height, get_height
export (int) var _width := 20 setget _set_width
export (int) var _length := 20 setget _set_length
export (int, 0, 315, 45) var _angle := 0 setget _set_angle

onready var _ready : bool = true
onready var _collider : CollisionPolygon2D = $CollisionPolygon2D
onready var _base : CompositePolygon2D = $Base
onready var _rise : RayCast2D = $Rise

var _shadows_to_draw : Dictionary = {}


func _draw() -> void:
	for texture in _shadows_to_draw:
		var texture_rect = _shadows_to_draw[texture]
		draw_texture_rect(texture, texture_rect, false, SHADOW_OPACTIY)


func _physics_process(delta: float) -> void:
	_shadows_to_draw.clear()
	update()


func get_class() -> String:
	return "ShadowMask"


func is_class(type: String) -> bool:
	return type == "ShadowMask" or .is_class(type)


func get_z_pos() -> int:
	return _z_pos


func get_top_z_pos(points: Array) -> int:
	var altitude = 0
	
	for point in points:
		point = to_local(point)
		altitude = max(altitude, _get_altitude(point))
	
	var fraction = 1.0 * altitude / float(_length)
	return _z_pos - int(ceil(_height * fraction))


func is_within(pos: Vector2) -> bool:
	var is_within := false
	var local_pos = to_local(pos) + Vector2(0, _z_pos)
	
	for shape in get_base_shapes(_z_pos):
		is_within = Geometry2D.point_in_polygon(local_pos, shape)
		if is_within:
			break
	
	return is_within


func draw_shadow(shadow: Shadow2D) -> void:
	var texture = shadow.texture
	var position_3d = shadow.get_global_pos()
	var position_2d = Vector2(position_3d.x, position_3d.y + _z_pos)
	var top_z_pos = get_top_z_pos([position_2d])
	var local_position = to_local(position_2d)
	
	var fraction = _get_size_fraction(position_3d)
	var texture_size = texture.get_size()
	texture_size = Vector2(texture_size.x * shadow.scale.x, texture_size.y * shadow.scale.y)
	var texture_position = local_position - (texture_size/2 * fraction) + Vector2(0, top_z_pos - _z_pos)
	var texture_rect = Rect2(texture_position, texture_size * fraction)
	_shadows_to_draw[texture] = texture_rect
	update()


func get_base_shapes(z_pos: int) -> Array:
	var polygons = []
	
	for polygon in _base.polygons:
		var translated_polygon = []
		for point in polygon:
			translated_polygon.append(point + _base.position)
		
		polygons.append(translated_polygon)
	
	return polygons


#Private getters and setters
func _set_z_pos(new_z_pos: int) -> void:
	_z_pos = new_z_pos


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


func _get_size_fraction(other_pos: Vector3) -> float:
	var other_position_2d = Vector2(other_pos.x, other_pos.y)
	var diff = abs(get_top_z_pos([other_position_2d]) - other_pos.z)
	var fraction := 1.0
	
	if diff >= MAX_DISTANCE_FROM_SHADOW:
		fraction = MIN_FRACTION_SIZE
	elif diff < MAX_DISTANCE_FROM_SHADOW:
		fraction = 1 - ((1 - MIN_FRACTION_SIZE) * diff / MAX_DISTANCE_FROM_SHADOW)
	
	return fraction


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
