tool
extends Area2D
class_name ShadowMask

const SHADOW_OPACTIY = Color(1, 1, 1, 0.5)
const MAX_DISTANCE_FROM_SHADOW = 100
const MIN_FRACTION_SIZE = 0.75

export (int) var _z_pos := 0 setget _set_z_pos, get_z_pos

onready var _base : CompositePolygon2D = $Base

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
	var top_z_pos = _z_pos
	return top_z_pos


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


func _get_size_fraction(other_pos: Vector3) -> float:
	var other_position_2d = Vector2(other_pos.x, other_pos.y)
	var diff = abs(get_top_z_pos([other_position_2d]) - other_pos.z)
	var fraction := 1.0
	
	if diff >= MAX_DISTANCE_FROM_SHADOW:
		fraction = MIN_FRACTION_SIZE
	elif diff < MAX_DISTANCE_FROM_SHADOW:
		fraction = 1 - ((1 - MIN_FRACTION_SIZE) * diff / MAX_DISTANCE_FROM_SHADOW)
	
	return fraction
