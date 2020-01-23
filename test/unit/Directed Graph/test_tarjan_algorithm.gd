extends "res://addons/gut/test.gd"

func test_acyclic_digraph() -> void:
	var digraph = DirectedGraph.new(4)
	digraph.add_edge(0, 2)
	digraph.add_edge(2, 1)
	digraph.add_edge(2, 3)
	
	var tarjan = TarjanAlgorithm.new(digraph)
	var output = tarjan.get_strongly_connected_components()
	var expected_output = [[1], [3], [2], [0]]
	assert_eq(output, expected_output, "Algorithm failed to say each vertex is an scc.")


func test_cyclic_digraph() -> void:
	var digraph = DirectedGraph.new(3)
	digraph.add_edge(0, 1)
	digraph.add_edge(1, 2)
	digraph.add_edge(2, 0)
	
	var tarjan = TarjanAlgorithm.new(digraph)
	var output = tarjan.get_strongly_connected_components()
	var expected_output = [[2, 1, 0]]
	assert_eq(output.size(), 1, "Algorithm failed to identify number of strongly connected components.")
	assert_eq(output, expected_output, "Algorithm failed to identify cycle.")


func test_digraph_with_single_cycle() -> void:
	var digraph = DirectedGraph.new(5)
	digraph.add_edge(0, 1)
	digraph.add_edge(1, 2)
	digraph.add_edge(2, 3)
	digraph.add_edge(3, 1)
	
	var tarjan = TarjanAlgorithm.new(digraph)
	var output = tarjan.get_strongly_connected_components()
	var expected_output = [[3, 2, 1], [0], [4]]
	assert_eq(output.size(), 3, "Algorithm failed to identify number of strongly connected components.")
	assert_eq(output, expected_output, "Algorithm failed to identify strongly connected components.")