tool
extends Node2D
class_name Shadow2D

const SHADOW_COLOR = Color(0, 0, 0, 0.5)

export (NodePath) var body
export (CapsuleShape2D) var shape setget _set_shape
export (int, 0, 19) var shadow_mask_layer

onready var _space_rid = get_world_2d().space
onready var _body = get_node(body)

func _draw() -> void:
	if Engine.editor_hint:
		draw_circle(position + Vector2(0, shape.height/2), shape.radius, SHADOW_COLOR)
		draw_circle(position - Vector2(0, shape.height/2), shape.radius, SHADOW_COLOR)
		
		var top_left = position - Vector2(shape.radius, shape.height/2)
		var bottom_right = position + Vector2(shape.radius, shape.height/2)
		var rect = Rect2(top_left, bottom_right - top_left)
		draw_rect(rect, SHADOW_COLOR)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	var space_state: Physics2DDirectSpaceState = Physics2DServer.space_get_direct_state(_space_rid)
	
	var shape_query_parameters = _generate_shape_query()
	
	var collision_results = space_state.intersect_shape(shape_query_parameters)
	
	for result in collision_results:
		result["collider"].draw_shadow(self)


func _set_shape(new_shape: CapsuleShape2D) -> void:
	shape = new_shape
	update()


func get_global_pos() -> Vector3:
	return _body.get_global_pos()


func _generate_shape_query() -> Physics2DShapeQueryParameters:
	var query = Physics2DShapeQueryParameters.new()
	
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_layer = 1 << shadow_mask_layer
	query.exclude = []
	query.margin = 0.0
	query.motion = Vector2(0, _body.get_z_pos())
	query.transform = get_global_transform()
	
	query.set_shape(shape)
	
	return query