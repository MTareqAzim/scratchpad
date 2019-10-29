tool
extends "in_air.gd"

export (int) var MAX_SPEED := 400
export (int) var GRAVITY := 1600
export (int) var COYOTE_FRAMES := 6

var _dashed : bool = false

func enter() -> void:
	owner.set_grav(GRAVITY)
	
	_dashed = action_buffer.action_within("air_dashed")
	action_buffer.action_handled("air_dashed")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	.enter()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_a"):
		if action_buffer.action_within("was_grounded", COYOTE_FRAMES):
			emit_signal("finished", "jump")
			get_tree().set_input_as_handled()
	
	if not _dashed and event.is_action_pressed("ui_x"):
		emit_signal("finished", "air dash")
		get_tree().set_input_as_handled()
	
	if not _dashed and event.is_action_pressed("ui_y"):
		emit_signal("finished", "air back dash")
		get_tree().set_input_as_handled()
	
	.handle_input(event)


func update(delta: float) -> void:
	if not _dashed and action_buffer.action_within("air_dashed"):
		_dashed = true
		action_buffer.action_handled("air_dashed")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	move_2d(input_direction, MAX_SPEED)
	.update(delta)