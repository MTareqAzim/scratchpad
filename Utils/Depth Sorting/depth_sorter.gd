extends Node
class_name DepthSorter

var _depth_sorts = []

func _ready() -> void:
	_append_depth_sorts(self)


func _append_depth_sorts(node: Node) -> void:
	for child in node.get_children():
		if child is DepthSort:
			_depth_sorts.append(child)
		if child.get_child_count() > 0:
			_append_depth_sorts(child)