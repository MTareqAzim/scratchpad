extends "res://addons/gut/test.gd"

func before_each():
	pass

func after_each():
	for child in get_children():
		child.free()

func before_all():
	pass

func after_all():
	pass