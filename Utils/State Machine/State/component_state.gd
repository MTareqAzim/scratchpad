tool
extends State
class_name ComponentState, "state.png"

var components : Array = []


func _ready() -> void:
	_append_components(self)


func get_class() -> String:
	return "ComponentState"


func is_class(type: String) -> bool:
	return type == "ComponentState" or .is_class(type)


func _append_components(node: Node) -> void:
	for child in node.get_children():
		if child is StateComponent:
			components.append(child)
			child.component_state = self
		
		if child.get_child_count() > 0:
			_append_components(child)


func enter() -> void:
	for component in components:
		if component.active and component.has_method("enter"):
			component.enter()


func exit() -> void:
	for component in components:
		if component.active and component.has_method("exit"):
			component.exit()


func handle_input(event) -> void:
	for component in components:
		if component.active and component.has_method("handle_input"):
			component.handle_input(event)


func update(delta: float) -> void:
	for component in components:
		if component.active and component.has_method("update"):
			component.update(delta)


func finished(next_state: String) -> void:
	emit_signal("finished", next_state)