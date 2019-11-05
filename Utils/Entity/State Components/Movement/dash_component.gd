extends EntityStateComponent

onready var _look_direction : LookDirection = get_node(look_direction)
onready var _timer : Timer = $Timer

export (NodePath) var look_direction
export (int) var dash_distance := 300
export (float) var dash_duration := 0.5
export (String) var next_state


func enter() -> void:
	_set_values()
	_timer.set_one_shot(true)
	_timer.start()


func update(delta: float) -> void:
	if _timer.is_stopped():
		component_state.finished(next_state)


func exit() -> void:
	_timer.stop()


func _set_values() -> void:
	var speed : float = dash_distance / dash_duration
	var direction : Vector2 = _look_direction.get_look_direction()
	
	$"Enter Velocity 2D".new_vector = direction * speed
	$Timer.set_wait_time(dash_duration)


func _on_Timer_timeout():
	component_state.finished(next_state)
