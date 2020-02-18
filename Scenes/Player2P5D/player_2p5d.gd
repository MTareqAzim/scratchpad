tool
extends KinematicBody2P5D

onready var _input_ui = $CanvasLayer/InputUIBase
onready var _input = $Input

func _on_Dialogue_Box_dialogue_start():
	_input_ui.hide()
	_input.set_input_direction(Vector2())
	_input.set_process_unhandled_input(false)


func _on_Dialogue_Box_dialogue_ended():
	_input_ui.show()
	_input.set_process_unhandled_input(true)
