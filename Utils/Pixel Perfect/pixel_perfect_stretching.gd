extends Node

const UPPER_CUTOFF := 0.8
const LOWER_CUTOFF := 0.3


func _ready():
	get_tree().connect("screen_resized", self, "_screen_resized")
	_screen_resized()

func _screen_resized():
	var window_size = OS.get_window_size()
	
	var scale_x = window_size.x / ProjectSettings.get_setting("display/window/size/width")
	var scale_y = window_size.y / ProjectSettings.get_setting("display/window/size/height")
	
	var shrink = max(1, max(scale_x, scale_y))
	var decimal = shrink - floor(shrink)
	if decimal >= UPPER_CUTOFF:
		shrink = round(shrink)
	elif decimal >= LOWER_CUTOFF:
		shrink = floor(shrink) + 0.5
	else:
		shrink = floor(shrink)
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(640, 360), shrink)
