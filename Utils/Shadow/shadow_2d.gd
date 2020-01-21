tool
extends Node2D
class_name Shadow2D

const SHADOW_COLOR = Color(0, 0, 0, 0.5)

export (NodePath) var body
export (Texture) var texture setget set_texture
export (int, 0, 19) var shadow_mask_layer

onready var _space_rid = get_world_2d().space
onready var _body = get_node(body)

func _draw() -> void:
	if Engine.editor_hint:
		draw_texture(texture, position - texture.get_size()/2)


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
	
	var direct_collision_result = \
			space_state.intersect_point(ray_from,
							32,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	var highest_shadow_mask = []
	var position_2d = Vector2(get_global_pos().x, get_global_pos().y)
	
	if direct_collision_result:
		for collision in direct_collision_result:
			var collider = collision["collider"]
			exclude.append(collision["rid"])
			if not collider.is_within(position_2d):
				continue
			var collider_z_pos = collider.get_z_pos()
			var collider_top_z_pos = collider.get_top_z_pos([position_2d + Vector2(0, collider_z_pos)])
			if highest_shadow_mask == []:
				highest_shadow_mask = [collider, collider_top_z_pos]
			elif collider_top_z_pos < highest_shadow_mask[1]:
				highest_shadow_mask = [collider, collider_top_z_pos]
	
	var collision_results = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	while collision_results:
		var collider = collision_results["collider"]
		exclude.append(collision_results["rid"])
		
		if collider.is_within(position_2d):
			var collider_z_pos = collider.get_z_pos()
			var collider_top_z_pos = collider.get_top_z_pos([position_2d + Vector2(0, collider_z_pos)])
			if collider.get_z_pos() >= _body.get_z_pos():
				if highest_shadow_mask == []:
					highest_shadow_mask = [collider, collider_top_z_pos]
				elif collider_top_z_pos < highest_shadow_mask[1]:
					highest_shadow_mask = [collider, collider_top_z_pos]
		
		collision_results = \
			space_state.intersect_ray(ray_from,
							ray_to,
							exclude,
							collision_layer,
							collide_with_bodies,
							collide_with_areas)
	
	return highest_shadow_mask