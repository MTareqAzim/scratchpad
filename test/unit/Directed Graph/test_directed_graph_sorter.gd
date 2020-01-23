extends "res://addons/gut/test.gd"

func test_kahn_sort() -> void:
	var digraph = DirectedGraph.new(4)
	digraph.add_edge(0, 2)
	digraph.add_edge(2, 1)
	digraph.add_edge(2, 3)
	
	var sorted_list = DirectedGraphSorter.kahn_sort(digraph)
	var expected_list = [0, 2, 1, 3]
	assert_eq(sorted_list, expected_list, "Different sorted outcome.")
	
	digraph = DirectedGraph.new(8)
	digraph.add_edge(0, 5)
	digraph.add_edge(5, 4)
	digraph.add_edge(5, 7)
	digraph.add_edge(3, 4)
	digraph.add_edge(4, 2)
	digraph.add_edge(4, 6)
	
	sorted_list = DirectedGraphSorter.kahn_sort(digraph)
	expected_list = [0, 1, 3, 5, 4, 7, 2, 6]
	assert_eq(sorted_list, expected_list, "Different sorted outcome.")