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
	
	digraph.add_edge(1, -2)
	assert_does_not_have(digraph.adjacent_to(1), -2, "Added a negative edge.")
	
	digraph.add_edge(0, 0)
	assert_does_not_have(digraph.adjacent_to(0), 0, "Added itself as an edge.")


func test_adjacent_to() -> void:
	var digraph = DirectedGraph.new(4)
	
	digraph.add_edge(3, 0)
	assert_has(digraph.adjacent_to(3), 0, "Does not have added edge.")