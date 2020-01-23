extends Reference
class_name TarjanAlgorithm

var digraph : DirectedGraph
var index : int = 0
var vertex_index = []
var vertex_lowlink = []
var vertex_on_stack = []
var stack = []
var strongly_connected_components = []


func _init(directed_graph: DirectedGraph):
	digraph = directed_graph
	
	for vertex in digraph.number_of_vertices():
		vertex_index.append(-1)
		vertex_lowlink.append(-1)
		vertex_on_stack.append(false)
	
	for vertex in digraph.number_of_vertices():
		if vertex_index[vertex] == -1:
			_strong_connect(vertex)


func get_strongly_connected_components() -> Array:
	return strongly_connected_components


func _strong_connect(vertex: int) -> void:
	vertex_index[vertex] = index
	vertex_lowlink[vertex] = index
	index = index + 1
	stack.push_front(vertex)
	vertex_on_stack[vertex] = true
	
	for vertex_to in digraph.adjacent_to(vertex):
		if vertex_index[vertex_to] == -1:
			_strong_connect(vertex_to)
			vertex_lowlink[vertex] = min(vertex_lowlink[vertex], vertex_lowlink[vertex_to])
		elif vertex_on_stack[vertex_to]:
			vertex_lowlink[vertex] = min(vertex_lowlink[vertex], vertex_index[vertex_to])
	
	if vertex_lowlink[vertex] == vertex_index[vertex]:
		var current_scc = []
		var vertex_to = stack.pop_front()
		vertex_on_stack[vertex_to] = false
		current_scc.append(vertex_to)
		
		while vertex_to != vertex:
			vertex_to = stack.pop_front()
			vertex_on_stack[vertex_to] = false
			current_scc.append(vertex_to)
		
		strongly_connected_components.append(current_scc)

