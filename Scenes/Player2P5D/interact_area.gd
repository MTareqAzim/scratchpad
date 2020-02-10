extends Area2D

export (NodePath) var body_path

onready var _body = get_node(body_path)


func get_body() -> KinematicBody2P5D:
	return _body
