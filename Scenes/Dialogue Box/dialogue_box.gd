extends Control
class_name DialogueBox

signal dialogue_start
signal dialogue_ended

onready var _dialogue_player : DialoguePlayer = $"Dialogue Player"

onready var _name_label : Label = $"Box/Name Label/Name"
onready var _dialogue_label : Label = $Box/Dialogue

var _finished := false


func _ready() -> void:
	set_process_input(false)


func _input(event) -> void:
	if event.is_action_pressed("ui_a"):
		if not _finished:
			_dialogue_player.next()
			_update_content()
		else:
			emit_signal("dialogue_ended")
			set_process_input(false)
			hide()
			get_tree().paused = false
		
		get_tree().set_input_as_handled()


func start(dialogue: Dictionary) -> void:
	_dialogue_player.start(dialogue)
	_finished = false
	_update_content()
	show()
	set_process_input(true)
	emit_signal("dialogue_start")
	get_tree().paused = true


func _update_content() -> void:
	_name_label.text = _dialogue_player.character_name
	_dialogue_label.text = _dialogue_player.text


func _on_Dialogue_Player_finished():
	_finished = true
