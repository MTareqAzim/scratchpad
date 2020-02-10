extends Node
class_name DialoguePlayer

signal finished

var character_name : String = ""
var text : String = ""

var _conversation : Array
var _index_current : int = 0


func start(dialogue_dictionary: Dictionary) -> void:
	_conversation = dialogue_dictionary.values()
	_index_current = 0
	_update()


func next() -> void:
	_index_current += 1
	assert(_index_current <= _conversation.size())
	_update()


func _update() -> void:
	text = _conversation[_index_current].text
	character_name = _conversation[_index_current].name
	if _index_current == _conversation.size() - 1:
		emit_signal("finished")
