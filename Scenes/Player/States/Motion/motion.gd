extends "../player_state.gd"

export (NodePath) var action_buffer_path

var action_buffer : ActionBuffer

func _ready():
	action_buffer = get_node(action_buffer_path)

func handle_input(event):
	if event.is_action_pressed("ui_right") \
	or event.is_action_pressed("ui_left") \
	or event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_down"):
		get_tree().set_input_as_handled()


func get_input_direction() -> Vector2:
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input_direction


func update_look_direction(direction: Vector2) -> void:
	if direction and owner.get_look_direction() != direction:
		owner.set_look_direction(direction)


func move_2d(direction: Vector2, speed: int) -> void:
	var velocity_2d = direction.normalized() * speed
	var z_velocity = owner.get_velocity().z
	var new_velocity = Vector3(velocity_2d.x, velocity_2d.y, z_velocity)
	owner.set_velocity(new_velocity)