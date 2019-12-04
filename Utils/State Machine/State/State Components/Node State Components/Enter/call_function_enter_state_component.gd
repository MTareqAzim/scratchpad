extends NodeStateComponent
class_name CallFuncitonEnterStateComponent, "fun_enter.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array) var args


func enter() -> void:
	if has_args:
		node.callv(FUNCTION_NAME, args)
	else:
		node.call(FUNCTION_NAME)
