tool
extends Node2D
class_name Shadow2D

const SHADOW_COLOR = Color(0, 0, 0, 0.5)

export (NodePath) var body
export (Texture) var texture
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
	
	var ray_from = global_position
	var ray_to = global_position - Vector2(0, _body.get_z_pos() - 1)
	var collide_with_areas = true
	var collide_with_bodies = false
	var collision_layer = 1 << shadow_mask_layer
	var exclude = []
	
	var collision_results = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	var highest_shadow_mask
	
	while collision_results:
		var shadow_mask = collision_results["collider"]
		if shadow_mask.get_z_pos() >= _body.get_z_pos():
			if highest_shadow_mask == null:
				highest_shadow_mask = shadow_mask
			if shadow_mask.get_z_pos() < highest_shadow_mask.get_z_pos():
				highest_shadow_mask = shadow_mask
		exclude.append(collision_results["rid"])
		collision_results = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	if highest_shadow_mask:
		highest_shadow_mask.draw_shadow(self)


func _set_shape(new_shape: CapsuleShape2D) -> void:
	shape = new_shape
	update()


func get_global_pos() -> Vector3:
	return _body.get_global_pos()


func _get_collisions(space_state: Physics2DDirectSpaceState) -> Dictionary:
	var collide_with_areas = true
	var collide_with_bodies = false
	var collision_layer = 1 << shadow_mask_layer
	var exclude = []
	
	var collisions = space_state.intersect_ray(global_position,
							global_position - Vector2(0, _body.get_z_pos()),
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	return collisions


func _generate_shape_query() -> Physics2DShapeQueryParameters:
	var query = Physics2DShapeQueryParameters.new()
	
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_layer = 1 << shadow_mask_layer
	query.exclude = []
	query.margin = 0.0
	query.motion = Vector2(0, -_body.get_z_pos())
	query.transform = get_global_transform()
	
	query.set_shape(shape)
	
	return query