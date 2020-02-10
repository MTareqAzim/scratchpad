extends KinematicBody2P5D

onready var _input_ui = $CanvasLayer/InputUIBase

func _on_Dialogue_Box_dialogue_start():
	_input_ui.hide()


func _on_Dialogue_Box_dialogue_ended():
	_input_ui.show()
