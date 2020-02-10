extends Node
class_name DialogueAction

signal finished

export (NodePath) var body_path
export (String, FILE, "*.json") var dialogue_file_path : String

onready var _body : KinematicBody2P5D = get_node(body_path)


func interact() -> void:
	var dialogue : Dictionary = load_dialogue(dialogue_file_path)
	yield(_body.play_dialogue(dialogue), "completed")
	emit_signal("finished")


func load_dialogue(file_path: String) -> Dictionary:
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue
