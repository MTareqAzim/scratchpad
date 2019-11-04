extends NodeStateComponent
class_name ModifyIntExitStateComponent, "int_exit.png"

export (String) var FUNCTION_NAME
export (int) var new_value


func exit() -> void:
	node.call(FUNCTION_NAME, new_value)
