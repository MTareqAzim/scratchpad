extends KinematicBody2P5D

export (NodePath) var dialogue_box_path

onready var _a_button : AnimatedSprite = $"A Button"
onready var _dialogue_action : DialogueAction = $DialogueAction
onready var _dialogue_box : DialogueBox = get_node(dialogue_box_path)

var _player : KinematicBody2P5D = null
var _has_player_focus : bool = false


func _ready():
	pass


func _process(delta):
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
			_dialogue_action.interact()
			get_tree().set_input_as_handled()


func play_dialogue(dialogue: Dictionary) -> void:
	_dialogue_box.start(dialogue)
	yield(_dialogue_box, "dialogue_ended")
	$Conversation/Area.disabled = true


func _on_Conversation_area_entered(area):
	_player = area.get_body()


func _on_Conversation_area_exited(area):
	_player = null
