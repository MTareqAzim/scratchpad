extends "../motion.gd"

export (Curve) var lunge_curve
export (int) var DASH_DISTANCE := 400
export (float) var DASH_DURATION := 0.5

onready var _timer = $Timer

var _direction : Vector2
var _enter_velocity : Vector3
var _prev_distance : float

func _ready():
	_timer.set_one_shot(true)

func enter():
	_direction = get_input_direction()
	update_look_direction(_direction)
	if _direction == Vector2.ZERO:
		_direction = owner.get_look_direction()
	
	_prev_distance = 0.0
	_timer.start(DASH_DURATION)
	owner.STEP_HEIGHT_LIMIT = 20
	.enter()


func handle_input(event) -> void:
	if event.is_action_pressed("ui_a"):
		action_buffer.add_event("ui_a_pressed")
		get_tree().set_input_as_handled()
	
	.handle_input(event)


func update(delta):
	var current_distance = DASH_DISTANCE * lunge_curve.interpolate(1 - (_timer.time_left / DASH_DURATION))
	var speed = (current_distance - _prev_distance) / delta
	move_2d(_direction, speed)
	_prev_distance = current_distance
	
	.update(delta)


func exit():
	owner.set_velocity(Vector3.ZERO)
	owner.STEP_HEIGHT_LIMIT = 10
	.exit()


func _fix_z_velocity(z_velocity: int) -> void:
	var velocity = owner.get_velocity()
	velocity.z = z_velocity
	owner.set_velocity(velocity)


func _on_Timer_timeout():
	call_deferred("emit_signal", "finished", "previous")
