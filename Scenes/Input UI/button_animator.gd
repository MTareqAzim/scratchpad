extends Control

onready var animation_player = $Sprite/AnimationPlayer

func animate_button(action: String, event: InputEvent):
	if event.is_action_pressed(action):
		animation_player.clear_queue()
		animation_player.queue("Press")
		animation_player.queue("Pressed")
	
	if event.is_action_released(action):
		animation_player.clear_queue()
		animation_player.queue("Depress")
		animation_player.queue("Idle")