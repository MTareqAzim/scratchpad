extends NodeStateComponent
class_name ModifyIntEnterStateComponent, "int_enter.png"

export (String) var FUNCTION_NAME
export (int) var new_value


func enter() -> void:
	node.call(FUNCTION_NAME, new_value)
