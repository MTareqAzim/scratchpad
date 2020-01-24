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
	return true


func _set_body(new_body: Node2D) -> void:
	_body = new_body