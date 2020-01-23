extends "res://addons/gut/test.gd"

func test_constructor() -> void:
	var digraph = DirectedGraph.new(1)
	assert_eq(digraph._adjacent.size(), 1, "Not properly setting vertices of digraph.")
	
	digraph = DirectedGraph.new(5)
	assert_eq(digraph._adjacent.size(), 5, "Not properly setting vertices of digraph.")
	
	digraph = DirectedGraph.new(0)
	assert_eq(digraph._adjacent.size(), 0, "Not properly setting vertices of digraph.")
	
	digraph = DirectedGraph.new(-3)
	assert_eq(digraph._adjacent.size(), 0, "Not properly setting vertices of digraph.")


func test_number_of_vertices() -> void:
	var digraph = DirectedGraph.new(1)
	assert_eq(digraph.number_of_vertices(), 1, "Not properly returning number of vertices.")
	
	digraph = DirectedGraph.new(5)
	assert_eq(digraph.number_of_vertices(), 5, "Not properly returning number of vertices.")
	
	digraph = DirectedGraph.new(0)
	assert_eq(digraph.number_of_vertices(), 0, "Not properly returning number of vertices.")
	
	digraph = DirectedGraph.new(-3)
	assert_eq(digraph.number_of_vertices(), 0, "Not properly returning number of vertices.")


func test_number_of_edges() -> void:
	var digraph = DirectedGraph.new(5)
	assert_eq(digraph.number_of_edges(), 0, "Wrong number of edges.")
	
	digraph.add_edge(1, 3)
	assert_eq(digraph.number_of_edges(), 1, "Wrong number of edges.")
	
	digraph.add_edge(2, 4)
	assert_eq(digraph.number_of_edges(), 2, "Wrong number of edges.")
	
	digraph.add_edge(2, 4)
	assert_eq(digraph.number_of_edges(), 2, "Wrong number of edges.")
	
	digraph.add_edge(0, 7)
	assert_eq(digraph.number_of_edges(), 2, "Wrong number of edges.")


func test_add_edge() -> void:
	var digraph = DirectedGraph.new(5)
	
	assert_does_not_have(digraph.adjacent_to(1), 3, "Has an edge before added.")
	digraph.add_edge(1, 3)
	assert_has(digraph.adjacent_to(1), 3, "Edge added wrong.")
	
	digraph.add_edge(1, 3)
	assert_ne(digraph.adjacent_to(1), [3, 3], "Added same edge twice.")
	
	digraph.add_edge(1, 0)
	assert_eq(digraph.adjacent_to(1), [0, 3], "Vertices not sorted.")
	
	digraph.add_edge(1, -2)
	assert_does_not_have(digraph.adjacent_to(1), -2, "Added a negative edge.")
	
	digraph.add_edge(0, 0)
	assert_does_not_have(digraph.adjacent_to(0), 0, "Added itself as an edge.")


func test_adjacent_to() -> void:
	var digraph = DirectedGraph.new(4)
	
	digraph.add_edge(3, 0)
	assert_has(digraph.adjacent_to(3), 0, "Does not have added edge.")


func test_erase() -> void:
	var digraph = DirectedGraph.new(5)
	digraph.add_edge(1, 2)
	digraph.add_edge(1, 3)
	
	assert_eq(digraph.number_of_edges(), 2, "Wrong number of edges.")
	assert_eq(digraph.adjacent_to(1), [2, 3], "Wrong directed edges.")
	assert_eq(digraph.indegree(2), 1, "Wrong indegree for vertex 2.")
	
	digraph.remove_edge(1, 2)
	assert_eq(digraph.number_of_edges(), 1, "Wrong number of edges.")
	assert_eq(digraph.adjacent_to(1), [3], "Wrong directed edges.")
	assert_eq(digraph.indegree(2), 0, "Wrong indegree for vertex 2.")


func test_copy() -> void:
	var digraph_original = DirectedGraph.new(5)
	digraph_original.add_edge(1, 3)
	digraph_original.add_edge(2, 4)
	
	var digraph_copy = DirectedGraphSorter.copy_directed_graph(digraph_original)
	assert_eq(digraph_copy.number_of_vertices(), 5, "Different number of vertices.")
	assert_eq(digraph_copy.number_of_edges(), 2, "Different number of edges.")
	assert_eq(digraph_copy.adjacent_to(1), [3], "Edge missing.")
	assert_eq(digraph_copy.adjacent_to(2), [4], "Edge missing.")
	
	digraph_copy.add_edge(0, 2)
	assert_ne(digraph_copy.number_of_edges(), digraph_original.number_of_edges(), "Same number of edges after only copy added a new edge.")
	assert_ne(digraph_original.adjacent_to(0), [2], "Edge missing.")
	assert_eq(digraph_copy.adjacent_to(0), [2], "Edge missing.")