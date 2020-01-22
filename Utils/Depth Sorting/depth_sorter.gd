extends Node
class_name DepthSorter

var _depth_sorts = []
var _depth_graph : DirectedGraph
var _z_indexes = []

func _ready() -> void:
	_append_depth_sorts(self)
	_depth_graph = _calculate_graph()
	_z_indexes = _calculate_z_indexes()
	_set_z_index_of_nodes()


func _physics_process(delta):
	_depth_graph = _calculate_graph()
	_z_indexes = _calculate_z_indexes()
	_set_z_index_of_nodes()


func _append_depth_sorts(node: Node) -> void:
	for child in node.get_children():
		if child is DepthSort:
			_depth_sorts.append(child)
		if child.get_child_count() > 0:
			_append_depth_sorts(child)


func _calculate_graph() -> DirectedGraph:
	var digraph = DirectedGraph.new(_depth_sorts.size())
	
	return digraph


func _calculate_z_indexes() -> Array:
	var z_indexes = []
	
	for i in _depth_sorts.size():
		z_indexes.append(i)
	
	return z_indexes


func _set_z_index_of_nodes() -> void:
	for i in _depth_sorts.size():
		_depth_sorts[i].set_body_z_index(_z_indexes[i])