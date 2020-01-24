extends Area2D
class_name DepthSort

export (NodePath) var body

onready var _body : Node2D = get_node(body) setget _set_body, get_body


func get_body() -> Node2D:
	return _body


func set_body_z_index(new_z_index: int) -> void:
	_body.set_z_index(new_z_index)


func get_overlapping_depth_sorts() -> Array:
	return get_overlapping_areas()


func in_front_of(depth_sort: DepthSort) -> bool:
	var in_front_of = false
	
	var body_y_position = _body.global_position.y
	var other_y_position = depth_sort.get_body().global_position.y
	in_front_of = body_y_position > other_y_position
	
	return in_front_of


func _set_body(new_body: Node2D) -> void:
	_body = new_body