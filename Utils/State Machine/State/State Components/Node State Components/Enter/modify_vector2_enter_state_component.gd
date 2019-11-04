extends NodeStateComponent
class_name ModifyVector2EnterStateComponent, "vec2_enter.png"

export (String) var FUNCTION_NAME
export (Vector2) var new_vector


func enter() -> void:
	node.call(FUNCTION_NAME, new_vector)
