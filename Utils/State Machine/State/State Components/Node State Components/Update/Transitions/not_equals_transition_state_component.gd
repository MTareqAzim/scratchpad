extends NodeStateComponent
class_name NotEqualsTransitionStateComponent, "not_equals_transition.png"

export (String) var FUNCTION_NAME
export (String) var not_equals
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable = str(node.call(FUNCTION_NAME))
	if variable != not_equals:
		component_state.finished(NEXT_STATE)