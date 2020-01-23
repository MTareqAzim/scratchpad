class_name DirectedGraphSorter


static func copy_directed_graph(digraph: DirectedGraph) -> DirectedGraph:
	var copy = DirectedGraph.new(digraph.number_of_vertices())
	
	for vertex in copy.number_of_vertices():
		for vertex_to in digraph.adjacent_to(vertex):
			copy.add_edge(vertex, vertex_to)
	
	return copy


static func kahn_sort(directed_graph: DirectedGraph) -> Array:
	var digraph = copy_directed_graph(directed_graph)
	var sorted_list = []
	var nodes_with_no_incoming_edges = []
	
	for vertex in digraph.number_of_vertices():
		if digraph.indegree(vertex) == 0:
			nodes_with_no_incoming_edges.append(vertex)
	
	while nodes_with_no_incoming_edges:
		var vertex = nodes_with_no_incoming_edges.pop_front()
		sorted_list.append(vertex)
		
		while digraph.adjacent_to(vertex):
			var vertex_to = digraph.adjacent_to(vertex).front()
			digraph.remove_edge(vertex, vertex_to)
			if digraph.indegree(vertex_to) == 0:
				nodes_with_no_incoming_edges.append(vertex_to)
	
	if digraph.number_of_edges() != 0:
		return []
	
	return sorted_list