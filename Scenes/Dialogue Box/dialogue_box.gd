extends Control
class_name DialogueBox

signal dialogue_start
signal dialogue_ended

const CHARS_PER_SECOND = 15

onready var _dialogue_player : DialoguePlayer = $"Dialogue Player"
onready var _tween : Tween = $Tween

onready var _name_label : Label = $"Box/Name Label/Name"
onready var _dialogue_label : Label = $Box/Dialogue

var _finished := false


func _ready() -> void:
	set_process_input(false)


func _input(event) -> void:
	if event.is_action_pressed("ui_a"):
		if _dialogue_label.percent_visible != 1:
			_tween.stop(_dialogue_label, "percent_visible")
			_dialogue_label.percent_visible = 1
		elif not _finished:
			_dialogue_player.next()
			_update_content()
		else:
			emit_signal("dialogue_ended")
			set_process_input(false)
			_finished = false
			hide()
		
		get_tree().set_input_as_handled()


func start(dialogue: Dictionary) -> void:
	_dialogue_player.start(dialogue)
	_update_content()
	show()
	set_process_input(true)
	emit_signal("dialogue_start")


func _update_content() -> void:
	_name_label.text = _dialogue_player.character_name
	_dialogue_label.text = _dialogue_player.text
	
	var text_time = _dialogue_label.text.length() / CHARS_PER_SECOND
	_dialogue_label.percent_visible = 0
	_tween.interpolate_property(
			_dialogue_label, "percent_visible", 0, 1, text_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	_tween.start()


func _on_Dialogue_Player_finished():
	_finished = true
