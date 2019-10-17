extends Control

onready var animation_player = $Sprite/AnimationPlayer

func _input(event):
	if event.is_action_pressed("ui_x"):
		animation_player.queue("Press")
		animation_player.queue("Pressed")
	
	if event.is_action_released("ui_x"):
		animation_player.queue("Depress")
		animation_player.queue("Idle")
