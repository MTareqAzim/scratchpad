extends NodeStateComponent
class_name ModifyStringExitStateComponent, "str_exit.png"

export (String) var FUNCTION_NAME
export (String) var new_string


func exit() -> void:
	node.call(FUNCTION_NAME, new_string)
