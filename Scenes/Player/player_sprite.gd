extends AnimatedSprite

const NORTH := Vector2(0, -1)
const NORTH_EAST := Vector2(1, -1)
const NORTH_WEST := Vector2(-1, -1)
const EAST := Vector2(1, 0)
const WEST := Vector2(-1, 0)
const SOUTH := Vector2(0, 1)
const SOUTH_EAST := Vector2(1, 1)
const SOUTH_WEST := Vector2(-1, 1)

var _state : String = "idle"
var _direction : String = "s"


func _play_proper_animation() -> void:
	var next_animation : String = _state + "_" + _direction
	play(next_animation)


func _on_Look_direction_changed(new_direction: Vector2) -> void:
	match new_direction:
		NORTH:
			_direction = "n"
		NORTH_EAST:
			_direction = "ne"
		NORTH_WEST:
			_direction = "nw"
		EAST:
			_direction = "e"
		WEST:
			_direction = "w"
		SOUTH:
			_direction = "s"
		SOUTH_EAST:
			_direction = "se"
		SOUTH_WEST:
			_direction = "sw"
	
	_play_proper_animation()
