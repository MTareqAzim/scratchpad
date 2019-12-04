extends NodeStateComponent
class_name CallFuncitonExitStateComponent, "fun_exit.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array) var args


func exit() -> void:
	if has_args:
		node.callv(FUNCTION_NAME, args)
	else:
		node.call(FUNCTION_NAME)
