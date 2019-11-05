extends NodeStateComponent
class_name ModifyStringEnterStateComponent, "str_enter.png"

export (String) var FUNCTION_NAME
export (String) var new_string


func enter() -> void:
	node.call(FUNCTION_NAME, new_string)
