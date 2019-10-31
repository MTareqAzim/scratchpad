extends NodeStateComponent
class_name GreaterThanTransitionStateComponent, "greater_than_transition.png"

export (String) var FUNCTION_NAME
export (float) var greater_than
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable = float(node.call(FUNCTION_NAME))
	if variable > greater_than:
		component_state.finished(NEXT_STATE)