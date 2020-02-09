extends Reference
class_name DirectedGraph

var _number_of_vertices : int = 0
var _number_of_edges : int = 0
var _adjacent : Array = []
var _indegree : Array = []

func _init(vertices: int):
	if vertices < 0:
		vertices = 0
	
	for i in vertices:
		_adjacent.append([])
		_indegree.append(0)
	
	_number_of_vertices = vertices


func number_of_vertices() -> int:
	return _number_of_vertices


func number_of_edges() -> int:
	return _number_of_edges


func add_edge(vertex_from: int, vertex_to: int) -> void:
	if _validate_vertex(vertex_from):
		return
	if _validate_vertex(vertex_to):
		return
	if vertex_from == vertex_to:
		return
	if _adjacent[vertex_from].has(vertex_to):
		return
	
	_adjacent[vertex_from].append(vertex_to)
	_adjacent[vertex_from].sort()
	_indegree[vertex_to] += 1
	_number_of_edges += 1


func remove_edge(vertex_from: int, vertex_to: int) -> void:
	if _validate_vertex(vertex_from):
		return
	if _validate_vertex(vertex_to):
		return
	if vertex_from == vertex_to:
		return
	if not _adjacent[vertex_from].has(vertex_to):
		return
	
	_adjacent[vertex_from].erase(vertex_to)
	_indegree[vertex_to] -= 1
	_number_of_edges -= 1


func adjacent_to(vertex: int) -> Array:
	if _validate_vertex(vertex):
		return []
	
	return _adjacent[vertex]


func outdegree(vertex: int) -> int:
	if _validate_vertex(vertex):
		return 0
	
	return _adjacent[vertex].size()


func indegree(vertex: int) -> int:
	if _validate_vertex(vertex):
		return 0
	
	return _indegree[vertex]


func _validate_vertex(vertex: int) -> bool:
	return vertex < 0 or vertex >= _number_of_vertices


func _to_string() -> String:
	var digraph_string = ""
	
	for index in _adjacent.size():
		digraph_string += String(index) + ": " + String(_adjacent[index])
		digraph_string += "\n"
	
	return digraph_string
