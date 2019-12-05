extends State
class_name ComponentState, "state.png"

export (Dictionary) var dependencies := {}

var _components : Array = []
var _dependencies : Dictionary = {}


func _ready() -> void:
	_append_components(self)
	_append_dependencies()
	_assign_dependencies()


func get_class() -> String:
	return "ComponentState"


func is_class(type: String) -> bool:
	return type == "ComponentState" or .is_class(type)


func enter() -> void:
	for component in _components:
		if component.active and component.has_method("enter"):
			component.enter()


func exit() -> void:
	for component in _components:
		if component.active and component.has_method("exit"):
			component.exit()


func handle_input(event: InputEvent) -> void:
	for component in _components:
		if component.active and component.has_method("handle_input"):
			component.handle_input(event)


func update(delta: float) -> void:
	for component in _components:
		if component.active and component.has_method("update"):
			component.update(delta)


func finished(next_state: String) -> void:
	emit_signal("finished", next_state)


func get_dependency(key: String) -> Node:
	return _dependencies[key]


func _append_components(node: Node) -> void:
	for child in node.get_children():
		if child is StateComponent:
			_components.append(child)
			child.component_state = self
		
		if child.get_child_count() > 0:
			if not child.get_class() == "ComponentState":
				_append_components(child)


func _append_dependencies() -> void:
	_dependencies.clear()
	for key in dependencies:
		_dependencies[key] = get_node(dependencies[key])


func _assign_dependencies() -> void:
	for component in _components:
		if component.has_method("assign_dependencies"):
			component.assign_dependencies()