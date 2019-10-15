extends Node
class_name ActionBuffer, "action-buffer-icon.png"

export (int) var FRAME_BUFFER_LIMIT := 60

var input_buffer: Dictionary = {}

func _physics_process(delta):
	for key in input_buffer:
		input_buffer[key] += 1
	
	input_buffer = _erase_old_inputs(input_buffer)


func add_event(key: String) -> void:
	input_buffer[key] = 0


func event_within(key: String, last_frames: int = FRAME_BUFFER_LIMIT) -> bool:
	if input_buffer.has(key):
		if input_buffer[key] < last_frames:
			return true
	
	return false


func event_handled(key: String) -> void:
	input_buffer.erase(key)


func _erase_old_inputs(buffer: Dictionary) -> Dictionary:
	var new_buffer := {}
	
	for key in buffer:
		if buffer[key] <= FRAME_BUFFER_LIMIT:
			new_buffer[key] = buffer[key]
	
	return new_buffer