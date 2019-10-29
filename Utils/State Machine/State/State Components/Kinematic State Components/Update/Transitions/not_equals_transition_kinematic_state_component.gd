tool
extends KinematicStateComponent
class_name NotEqualsTransitionKinematicStateComponent, "not_equals_transition.png"

export (String) var FUNCTION_NAME
export (String) var not_equals
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable = str(body.call(FUNCTION_NAME))
	if variable != not_equals:
		component_state.finished(NEXT_STATE)