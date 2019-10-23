extends Control

export (String) var ACTION := ""

onready var animation_player = $Sprite/AnimationPlayer

func _input(event):
	animate_button(ACTION, event) 


func animate_button(action: String, event: InputEvent):
	if event.is_action_pressed(action):
		animation_player.clear_queue()
		animation_player.queue("Press")
		animation_player.queue("Pressed")
	
	if event.is_action_released(action):
		animation_player.clear_queue()
		animation_player.queue("Depress")
		animation_player.queue("Idle")