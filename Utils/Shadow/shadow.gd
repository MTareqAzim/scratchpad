extends Sprite

const GLOBAL_GROUND = 0

export (NodePath) var body
export (int) var max_z_pos := -100
export (float, 0.0, 1.0, 0.01) var smallest_size := 0.75

onready var _body : KinematicBody2D = get_node(body)
onready var _original_scale : Vector2 = get_scale()


func _physics_process(delta):
	var z_pos = _body.get_z_pos()
	_set_shadow_scale(z_pos)


func _set_shadow_scale(z_pos: int) -> void:
	var scale_multiplier : float = 1.0
	
	if z_pos < max_z_pos:
		scale_multiplier = smallest_size
	elif z_pos < GLOBAL_GROUND:
		scale_multiplier = 1.0 - (z_pos / float(max_z_pos)) * (1.0 - smallest_size)

	var new_scale = _original_scale * scale_multiplier
	set_scale(new_scale)
