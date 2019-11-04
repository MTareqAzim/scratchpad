extends NodeStateComponent
class_name ModifyIntUpdateStateComponent, "int_update.png"

export (String) var FUNCTION_NAME
export (int) var new_value


func update(delta: float) -> void:
	node.call(FUNCTION_NAME, new_value)
