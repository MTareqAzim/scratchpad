extends EntityStateComponent

onready var _timer : Timer = $Timer

export (String) var duration_key := "stand_up_duration"
export (String) var next_state

var _duration : float = 0.2


func enter() -> void:
	_set_values()
	_timer.set_one_shot(true)
	_timer.start()


func exit() -> void:
	_timer.stop()


func assign_variables() -> void:
	_duration = component_state.get_variable(duration_key)


func _set_values() -> void:
	_timer.set_wait_time(_duration)


func _on_Timer_timeout():
	component_state.finished(next_state)
