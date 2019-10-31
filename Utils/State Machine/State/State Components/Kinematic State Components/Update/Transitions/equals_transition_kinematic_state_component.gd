extends KinematicStateComponent
class_name EqualsTransitionKinematicStateComponent, "equals_transition.png"

export (String) var FUNCTION_NAME
export (String) var equals
export (String) var NEXT_STATE


func update(delta: float) -> void:
	var variable = str(body.call(FUNCTION_NAME))
	if variable == equals:
		component_state.finished(NEXT_STATE)