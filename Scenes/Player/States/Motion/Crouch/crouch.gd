extends "../motion.gd"

export (float) var CROUCH_DELAY := 0.1
export (int) var MAX_SPEED := 200
export (int) var CROUCH_HEIGHT := 50

onready var _timer = $Timer

var _prev_height : int
var was_grounded : bool

func _ready():
	_timer.set_one_shot(true)

func enter() -> void:
	_prev_height = owner.get_height()
	was_grounded = owner.is_grounded()
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	owner.set_height(CROUCH_HEIGHT)
	.enter()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_b"):
		if not _timer.is_stopped():
			_timer.stop()
		get_tree().set_input_as_handled()
	
	if event.is_action_released("ui_b"):
		_timer.start(CROUCH_DELAY)
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
		if _timer.is_stopped():
			_timer.start(CROUCH_DELAY)
	
	if not owner.is_grounded() and owner.get_velocity().z > 0:
		emit_signal("finished", "previous")
	
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	move_2d(input_direction, MAX_SPEED)
	.update(delta)


func exit():
	if not _timer.is_stopped():
		_timer.stop()
	
	if was_grounded:
		action_buffer.add_action("was_grounded")
	
	owner.set_height(_prev_height)
	.exit()


func _on_Timer_timeout():
	call_deferred("emit_signal", "finished", "previous")
