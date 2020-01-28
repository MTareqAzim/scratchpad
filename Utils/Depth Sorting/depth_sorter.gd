extends Node2D
class_name DepthSorter

var _depth_sorts = []
var _depth_graph : DirectedGraph
var _z_indexes = []
var _player_vertex = 0

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
	
	for vertex in _depth_sorts.size():
		var depth_sort = _depth_sorts[vertex]
		for other_depth_sort in depth_sort.get_overlapping_depth_sorts():
			if depth_sort.in_front_of(other_depth_sort):
				var vertex_to = _depth_sorts.find(other_depth_sort)
				digraph.add_edge(vertex, vertex_to)
	
	var tarjan = TarjanAlgorithm.new(digraph)
	var strongly_connected_components = tarjan.get_strongly_connected_components()
	var cycles = []
	
	for scc in strongly_connected_components:
		if scc.size() > 1:
			cycles.append(scc)
	
	for cycle in cycles:
		var vertex_to = cycle[0]
		for vertex in cycle:
			vertex_to = max(vertex_to, vertex)
		var index = cycle.find(vertex_to)
		var vertex = cycle[(index + 1) % cycle.size()]
		digraph.remove_edge(vertex, vertex_to)
	
	return digraph


func _calculate_z_indexes() -> Array:
	var z_indexes = DirectedGraphSorter.kahn_sort(_depth_graph)
	z_indexes.invert()
	
	return z_indexes


func _set_z_index_of_nodes() -> void:
	if _z_indexes == []:
		return
	
	for i in _depth_sorts.size():
		_depth_sorts[i].set_body_z_index(_z_indexes.find(i))