tool
extends StaticBody2P5D

export (int) var _z_pos: = 0 setget _set_z, get_z_pos
export (int) var _height: = 0 setget _set_height, get_height

var _first_time: = [true, true]

func get_z_pos() -> int:
	return _z_pos


func get_height() -> int:
	return _height


func get_base_shapes(z_pos: int) -> Array:
	var base_area = $BaseArea2P5D
	var shapes = []
	
	if z_pos <= _z_pos and z_pos >= _z_pos - _height:
		for owner in base_area.get_shape_owners():
			for shape_id in base_area.shape_owner_get_shape_count(owner):
				shapes.append(base_area.shape_owner_get_shape(owner, shape_id))
	
	return shapes


func get_base_transform() -> Transform2D:
	var base_shape = $BaseArea2P5D/BaseShape
	return base_shape.get_global_transform()


func get_top_z_pos(points: Array) -> int:
	return $TopArea2P5D.get_top_z_pos(points)


func _set_z(new_z: int) -> void:
	var diff = _z_pos - new_z
	_z_pos = new_z
	
	if _first_time[0]:
		_first_time[0] = false
	else:
		translate(Vector2(0, -diff))
		_update_dist_to_ground()


func _set_height(new_height: int) -> void:
	_height = new_height
	
	if _first_time[1]:
		_first_time[1] = false
	else:
		_update_volume()
		_update_top()


#Editor functions
func _update_volume() -> void:
	var volume_shape = $VolumeShape
	var base_shape = $BaseArea2P5D/BaseShape
	
	var points = base_shape.polygon
	var start_point = points[0]
	var min_x = start_point.x
	var max_x = min_x
	var min_y = start_point.y
	var max_y = min_y
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	var vector_array = [Vector2(min_x, min_y - _height), Vector2(max_x, min_y - _height), Vector2(max_x, max_y), Vector2(min_x, max_y)]
	volume_shape.polygon = PoolVector2Array(vector_array)
	volume_shape.position = base_shape.position


func _update_top() -> void:
	var top = $TopArea2P5D
	var top_shape = $TopArea2P5D/TopShape
	var base_shape = $BaseArea2P5D/BaseShape
	
	top_shape.polygon = base_shape.polygon
	top_shape.position = Vector2.ZERO
	top.position = base_shape.position - Vector2(0, _height)


func _update_dist_to_ground() -> void:
	var raycast = $DistToGround
	raycast.set_cast_to(Vector2(0, -_z_pos))
	raycast.visible = raycast.cast_to != Vector2.ZERO


func _on_BaseShape_draw() -> void:
	if Engine.is_editor_hint():
		_update_volume()
		_update_top()