extends KinematicStateComponent
class_name LessThanTransitionKinematicStateComponent, "less_than_transition.png"

export (String) var FUNCTION_NAME
export (float) var comparison
export (String) var NEXT_STATE

func update(delta: float) -> void:
	var variable = float(body.call(FUNCTION_NAME))
	if variable < comparison:
		component_state.finished(NEXT_STATE)