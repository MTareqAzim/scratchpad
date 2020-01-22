class_name DirectedGraph

var _number_of_vertices : int = 0
var _number_of_edges : int = 0
var _adjacent : Array = []

func _init(vertices: int):
	if vertices < 0:
		vertices = 0
	
	for i in vertices:
		_adjacent.append([])
	
	_number_of_vertices = vertices


func number_of_vertices() -> int:
	return _number_of_vertices


func number_of_edges() -> int:
	return _number_of_edges


func add_edge(vertex_from: int, vertex_to: int) -> void:
	if vertex_from < 0 or vertex_from >= _number_of_vertices:
		return
	if vertex_to < 0 or vertex_to >= _number_of_vertices:
		return
	if vertex_from == vertex_to:
		return
	if _adjacent[vertex_from].has(vertex_to):
		return
	
	_adjacent[vertex_from].append(vertex_to)
	_number_of_edges = _number_of_edges + 1


func adjacent_to(vertex: int) -> Array:
	if vertex < 0 or vertex >= _number_of_vertices:
		return []
	
	return _adjacent[vertex]