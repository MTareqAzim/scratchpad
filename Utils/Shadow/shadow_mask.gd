tool
extends Area2D
class_name ShadowMask

export (int) var z_pos := 0 setget _set_z_pos, get_z_pos

onready var _ready : bool = true


func _set_z_pos(new_z_pos: int) -> void:
	var diff = z_pos - new_z_pos
	z_pos = new_z_pos
	
	if _ready:
		translate(Vector2(0, -diff))


func get_z_pos() -> int:
	return z_pos


func draw_shadow(shadow: Shadow2D) -> void:
	pass

