extends NodeStateComponent
class_name CallFuncitonUpdateStateComponent, "fun_update.png"

export (String) var FUNCTION_NAME
export (bool) var has_args := true
export (Array) var args


func update(delta: float) -> void:
	if has_args:
		node.callv(FUNCTION_NAME, args)
	else:
		node.call(FUNCTION_NAME)
