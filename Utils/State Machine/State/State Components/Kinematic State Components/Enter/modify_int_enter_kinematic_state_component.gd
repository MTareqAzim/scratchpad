tool
extends KinematicStateComponent
class_name ModifyIntEnterKinematicStateComponent, "int.png"

export (String) var FUNCTION_NAME
export (int) var new_value


func enter() -> void:
	body.call(FUNCTION_NAME, new_value)
