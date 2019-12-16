extends Node
class_name Health

signal health_changed(health)

export (int, 0, 2147483647) var max_health

onready var _health : int = max_health


func damage_health(amount: int) -> void:
	var previous_health = _health
	var new_health = _health - amount
	_health = int(clamp(new_health, 0, max_health))
	
	if _health != previous_health:
		emit_signal("health_changed", _health)


func get_health() -> int:
	return _health
