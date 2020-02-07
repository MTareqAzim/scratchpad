extends KinematicBody2D

const SPEED = 50

var direction = Vector2()
var motion = Vector2()


func _physics_process(delta):
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	motion = direction.normalized() * SPEED
	
	var collision : KinematicCollision2D = move_and_collide(motion * delta)
	if collision:
		while collision:
			#Do something with the collision object
			var collided_object = collision.get_collider()
			
			#Collision resolution
			var collided_normal = collision.get_normal().normalized()
			var remainder = collision.get_remainder()
			var component_vector = collided_normal * remainder.dot(collided_normal)
			var resolution_vector = remainder - component_vector
			if resolution_vector == Vector2.ZERO:
				collision = null
			else:
				collision = move_and_collide(resolution_vector)
