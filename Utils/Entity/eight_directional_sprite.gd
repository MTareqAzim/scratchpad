extends Node2D

const NORTH := Vector2(0, -1)
const NORTH_EAST := Vector2(1, -1)
const NORTH_WEST := Vector2(-1, -1)
const EAST := Vector2(1, 0)
const WEST := Vector2(-1, 0)
const SOUTH := Vector2(0, 1)
const SOUTH_EAST := Vector2(1, 1)
const SOUTH_WEST := Vector2(-1, 1)

export (String) var initial_state
export (String) var initial_direction

onready var e = $E
onready var n = $N
onready var ne = $NE
onready var nw = $NW
onready var s = $S
onready var se = $SE
onready var sw = $SW
onready var w = $W

var _state = "idle"
var _direction = "e"
onready var _current_sprite : AnimatedSprite = e


func _ready():
	_state = initial_state
	_direction = initial_direction
	_play_proper_animation()


func _play_proper_animation() -> void:
	_set_proper_sprite_visible()
	_play_animation()


func _set_proper_sprite_visible() -> void:
	var new_sprite = get(_direction)
	if _current_sprite != new_sprite:
		_current_sprite.set_visible(false)
		_current_sprite.stop()
		
		_current_sprite = new_sprite
		_current_sprite.set_visible(true)


func _play_animation() -> void:
	_current_sprite.play(_state)


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


func _on_State_Machine_state_changed(current_state):
	_state = current_state
	
	_play_proper_animation()
