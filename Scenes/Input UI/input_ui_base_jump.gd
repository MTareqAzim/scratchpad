extends TextureRect

onready var _a_text = $ATextBox


func _on_Interact_area_entered(area):
	_a_text.set_text("Talk")



func _on_Interact_area_exited(area):
	_a_text.set_text("Jump")
