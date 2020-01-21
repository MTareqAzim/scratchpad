tool
extends Area2D
class_name ShadowMask

const HALF_OPACTIY = Color(1, 1, 1, 0.5)

export (int) var z_pos := 0 setget _set_z_pos, get_z_pos

onready var _ready : bool = true
onready var _collider : CollisionShape2D = $CollisionShape2D

var shadows_to_draw : Dictionary = {}


func _draw() -> void:
	for texture in shadows_to_draw:
		draw_texture(texture, shadows_to_draw[texture], HALF_OPACTIY)


func _physics_process(delta: float) -> void:
	shadows_to_draw.clear()
	update()


func _set_z_pos(new_z_pos: int) -> void:
	var diff = z_pos - new_z_pos
	z_pos = new_z_pos
	
	if _ready:
		translate(Vector2(0, -diff))


func get_z_pos() -> int:
	return z_pos


func set_extents(new_extents: Vector2) -> void:
	_collider.shape.extents = new_extents


func draw_shadow(shadow: Shadow2D) -> void:
	var texture = shadow.texture
	var position_3d = shadow.get_global_pos()
	var position_2d = Vector2(position_3d.x, position_3d.y + z_pos)
	var local_position = to_local(position_2d)
	
	for shape in get_base_shapes():
		if Geometry2D.point_in_polygon(local_position, shape):
			shadows_to_draw[texture] = local_position - texture.get_size()/2
			update()

func get_base_shapes() -> Array:
	var shapes = []
	
	var extents = _collider.shape.extents
	var rect_position = Vector2(-extents.x, -extents.y)
	var rect_size = Vector2(extents.x, extents.y) * 2
	var rect = Rect2(rect_position, rect_size) 
	
	shapes.append(Geometry2D.rect_to_array(rect))
	
	return shapes