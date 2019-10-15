extends "../motion.gd"

export (int) var JUMP_BUFFER_FRAMES = 6

var speed := 0
var velocity := Vector3()
var was_grounded : bool

func enter():
	was_grounded = owner.is_grounded()
	.enter()


func handle_input(event: InputEvent) -> void:
	if was_grounded and event.is_action_pressed("ui_a"):
		emit_signal("finished", "jump")
		was_grounded = false
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_b"):
		was_grounded = false
		emit_signal("finished", "crouch")
		get_tree().set_input_as_handled()
	
	if owner.is_grounded() and event.is_action_pressed("ui_x"):
		emit_signal("finished", "lunge")
		get_tree().set_input_as_handled()
	
	if owner.is_grounded() and event.is_action_pressed("ui_y"):
		emit_signal("finished", "retreat")
		get_tree().set_input_as_handled()
	
	.handle_input(event)


func update(delta) -> void:
	if owner.is_grounded():
		was_grounded = true
	
	if not owner.is_grounded() and owner.get_velocity().z > 0:
		emit_signal("finished", "fall")
	
	if owner.is_grounded() and Input.is_action_pressed("ui_b"):
		was_grounded = false
		emit_signal("finished", "crouch")
	
	if owner.is_grounded() and action_buffer.event_within("ui_a_pressed", JUMP_BUFFER_FRAMES):
		was_grounded = false
		emit_signal("finished", "jump")
	
	.update(delta)


func exit():
	if was_grounded:
		action_buffer.add_event("was_grounded")
	
	.exit()