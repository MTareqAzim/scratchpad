tool
extends Node2D
class_name Shadow2D

const HALF_OPACITY = Color(1, 1, 1, 0.5)

export (NodePath) var body
export (Texture) var texture setget set_texture
export (int, 0, 19) var shadow_mask_layer

onready var _space_rid = get_world_2d().space
onready var _body = get_node(body)

func _draw() -> void:
	if Engine.editor_hint:
		draw_texture(texture, position - texture.get_size()/2, HALF_OPACITY)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	var space_state: Physics2DDirectSpaceState = Physics2DServer.space_get_direct_state(_space_rid)
	
	var highest_shadow_mask = _get_highest_shadow_mask(space_state, global_position)
	
	if highest_shadow_mask != []:
		highest_shadow_mask[0].draw_shadow(self)


func set_texture(new_texture: Texture) -> void:
	texture = new_texture
	update()


func get_global_pos() -> Vector3:
	return _body.get_global_pos()


func _get_highest_shadow_mask(space_state: Physics2DDirectSpaceState, ray_from: Vector2) -> Array:
	var ray_to = ray_from - Vector2(0, _body.get_z_pos())
	var collide_with_areas = true
	var collide_with_bodies = false
	var collision_layer = 1 << shadow_mask_layer
	var exclude = []
	var highest_shadow_mask = []
	var position_2d = ray_from - Vector2(0, get_global_pos().z)
	
	var direct_collision_result = \
			space_state.intersect_point(ray_from,
							32,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	if direct_collision_result:
		for collision in direct_collision_result:
			var shadow_mask = collision["collider"]
			exclude.append(collision["rid"])
			if not shadow_mask.is_within(position_2d):
				continue
			highest_shadow_mask = _compare_with_highest_shadow_mask(shadow_mask, 
										highest_shadow_mask, position_2d)
	
	var collision_result = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	while collision_result:
		var shadow_mask = collision_result["collider"]
		exclude.append(collision_result["rid"])
		
		if shadow_mask.is_within(position_2d):
			highest_shadow_mask = _compare_with_highest_shadow_mask(shadow_mask,
										highest_shadow_mask, position_2d)
		
		collision_result = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	return highest_shadow_mask


func _compare_with_highest_shadow_mask(shadow_mask, highest_shadow_mask, position_2d) -> Array:
	var shadow_mask_z_pos = shadow_mask.get_z_pos()
	var shadow_mask_top_z_pos = shadow_mask.get_top_z_pos([position_2d + Vector2(0, shadow_mask_z_pos)])
	if shadow_mask_top_z_pos >= _body.get_z_pos():
		if highest_shadow_mask == []:
			highest_shadow_mask = [shadow_mask, shadow_mask_top_z_pos]
		elif shadow_mask_top_z_pos < highest_shadow_mask[1]:
			highest_shadow_mask = [shadow_mask, shadow_mask_top_z_pos]
	
	return highest_shadow_mask