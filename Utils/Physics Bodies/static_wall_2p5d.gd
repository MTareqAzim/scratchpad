tool
extends StaticBody2P5D

export (int) var _z_pos: = 0 setget _set_z, get_z_pos
export (int) var _height: = 0 setget _set_height, get_height

onready var base_shape = $BaseShape
onready var top_shape = $TopShape
onready var volume_shape = $VolumeShape
onready var dist_to_ground = $DistToGround
onready var ready := true

func get_z_pos() -> int:
	return _z_pos


func get_height() -> int:
	return _height


func get_base_shapes(z_pos: int) -> Array:
	return base_shape.get_polygons()


func get_base_transform() -> Transform2D:
	return base_shape.get_global_transform()


func get_top_z_pos(points: Array) -> int:
	return _z_pos - _height


func _set_z(new_z: int) -> void:
	var diff = _z_pos - new_z
	_z_pos = new_z
	
	if ready:
		translate(Vector2(0, -diff))
		_update_dist_to_ground()


func _set_height(new_height: int) -> void:
	_height = new_height
	_update_components()


#Editor functions
func _update_components() -> void:
	if not ready:
		return
	
	_update_top()
	_update_volume()


func _update_volume() -> void:
	var points: Array = base_shape.polygon
	var bounding_box: Rect2 = Geometry2D.bounding_box(points)
	
	var vector_array = [bounding_box.position + Vector2(0, -_height),
			bounding_box.position + Vector2(bounding_box.size.x, -_height),
			bounding_box.position + bounding_box.size,
			bounding_box.position + Vector2(0, bounding_box.size.y)]
	
	volume_shape.polygon = PoolVector2Array(vector_array)
	volume_shape.position = base_shape.position


func _update_top() -> void:
	top_shape.polygon = base_shape.polygon
	top_shape.position = base_shape.position - Vector2(0, _height)


func _update_dist_to_ground() -> void:
	dist_to_ground.set_cast_to(Vector2(0, -_z_pos))
	dist_to_ground.visible = dist_to_ground.cast_to != Vector2.ZERO


func _on_CompositePolygon2D_polygon_changed():
	if Engine.is_editor_hint():
		call_deferred("_update_components")
