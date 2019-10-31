extends NodeStateComponent
class_name EqualsTransitionStateComponent, "equals_transition.png"

export (String) var FUNCTION_NAME
export (String) var equals
export (String) var NEXT_STATE


func update(delta: float) -> void:
	var variable = str(node.call(FUNCTION_NAME))
	if variable == equals:
		component_state.finished(NEXT_STATE)