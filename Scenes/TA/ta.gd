extends KinematicBody2P5D

onready var _a_button : AnimatedSprite = $"A Button"

var _has_player_focus : bool = false


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("ui_a"):
		if _has_player_focus:
			get_tree().set_input_as_handled()


func _on_Conversation_area_entered(area):
	_a_button.set_visible(true)
	_a_button.play("pressed")
	_has_player_focus = true


func _on_Conversation_area_exited(area):
	_a_button.set_visible(false)
	_a_button.stop()
	_has_player_focus = false
