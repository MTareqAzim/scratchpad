extends "../motion.gd"

export (int) var MAX_SPEED := 200
export (int) var CROUCH_HEIGHT := 50

var _prev_height : int
var was_grounded : bool

func enter() -> void:
	_prev_height = owner.get_height()
	was_grounded = owner.is_grounded()
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	owner.set_height(CROUCH_HEIGHT)
	.enter()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_b"):
		emit_signal("finished", "previous")
		get_tree().set_input_as_handled()
	
	if was_grounded and event.is_action_pressed("ui_a"):
		emit_signal("finished", "high jump")
		was_grounded = false
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_x"):
		emit_signal("finished", "somersault")
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_y"):
		emit_signal("finished", "back roll")
		get_tree().set_input_as_handled()
	
	.handle_input(event)


func update(delta: float) -> void:
	if not Input.is_action_pressed("ui_b"):
		emit_signal("finished", "previous")
	
	if not owner.is_grounded() and owner.get_velocity().z > 0:
		emit_signal("finished", "previous")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	move_2d(input_direction, MAX_SPEED)
	.update(delta)


func exit():
	if was_grounded:
		action_buffer.add_event("was_grounded")
	
	owner.set_height(_prev_height)
	.exit()