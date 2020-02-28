extends InputHandler
class_name PlayerInputHandler, "input.png"

onready var _state_machine : StateMachine = get_node(state_machine)
onready var _action_buffer : ActionBuffer = get_node(action_buffer)

export (NodePath) var state_machine
export (NodePath) var action_buffer

var _map : Array = []
var _input_direction : Vector2 = Vector2()


func _ready():
	repopulate_map()


func _unhandled_input(event):
	if event.is_action("ui_right") \
	or event.is_action("ui_left") \
	or event.is_action("ui_up") \
	or event.is_action("ui_down"):
		get_tree().set_input_as_handled()
		_input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		_input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	for action_map in _map:
		var mapped_event = action_map.map(event)
		if mapped_event:
			_register_event(mapped_event)
			_state_machine.handle_input(mapped_event)
			get_tree().set_input_as_handled()


func set_input_direction(new_input_direction: Vector2) -> void:
	_input_direction = new_input_direction


func add_child(node: Node, legible_unique_name: bool = false) -> void:
	.add_child(node, legible_unique_name)
	repopulate_map()


func remove_child(node: Node) -> void:
	.remove_child(node)
	repopulate_map()


func get_direction() -> Vector2:
	return _input_direction


func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)


func repopulate_map() -> void:
	_map = _populate_map()


func _populate_map() -> Array:
	var map : Array = []
	
	for i in get_child_count():
		var child = get_child(i)
		if child is ActionMap:
			map.append(child)
	
	return map


func _register_event(event: InputEventAction) -> void:
	if event.is_pressed():
		Input.action_press(event.get_action(), 1)
		_action_buffer.add_action(event.get_action() + "_pressed")
	else:
		Input.action_release(event.get_action())
		_action_buffer.add_action(event.get_action() + "_released")


func _on_animation_finished():
	_state_machine.on_animation_finished("finish")
