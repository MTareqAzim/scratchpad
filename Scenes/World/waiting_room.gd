extends Node2D

onready var _dialogue_box : DialogueBox = $"CanvasLayer/Dialogue Box"


func play_dialogue(dialogue: Dictionary) -> void:
	_dialogue_box.start(dialogue)
	yield(_dialogue_box, "dialogue_ended")
