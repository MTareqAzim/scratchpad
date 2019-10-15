extends Area2D
class_name StaticBody2P5D

func get_z_pos() -> int:
	return 0


func get_height() -> int:
	return 0


func get_base_shapes(z_pos: int) -> Array:
	return []


func get_base_transform() -> Transform2D:
	return Transform2D()


func get_top_z_pos(points: Array) -> int:
	return 0