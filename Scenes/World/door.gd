extends Sprite

onready var _a_button : AnimatedSprite = $"A Button"
onready var _area_polygon : CollisionPolygon2D = $Area2D/CollisionPolygon2D

var _player : KinematicBody2P5D = null
var _has_player_focus : bool = false


func _ready() -> void:
	_area_polygon.disabled = true


func _process(delta) -> void:
	if _player and _player.is_grounded():
		if not _has_player_focus:
			_a_button.set_visible(true)
			_a_button.play("press")
			_has_player_focus = true
	else:
		if _has_player_focus:
			_a_button.set_visible(false)
			_a_button.stop()
			_has_player_focus = false


func _input(event):
	if event.is_action_pressed("ui_a"):
		if _has_player_focus:
			get_tree().set_input_as_handled()


func _on_Area2D_area_entered(area) -> void:
	_player = area.get_body()


func _on_Area2D_area_exited(area) -> void:
	_player = null


func _on_TA_introduction_finished():
	_area_polygon.disabled = false
