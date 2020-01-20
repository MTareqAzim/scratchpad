extends Control

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export (String) var ACTION := ""


func _input(event):
	animate_button(ACTION, event) 


func animate_button(action: String, event: InputEvent):
	if event.is_action_pressed(action):
		animated_sprite.play("press")
	
	if event.is_action_released(action):
		animated_sprite.play("depress")

func _on_AnimatedSprite_animation_finished():
	if animated_sprite.get_animation() == "depress":
		animated_sprite.play("idle")
