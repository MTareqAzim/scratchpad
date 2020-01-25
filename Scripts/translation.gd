extends Node

const Language_id = ["en","da"]

var choosenLanguage = "en"

func _on_OptionButton_pressed():
	var current_language = TranslationServer.get_locale()
	var id = Language_id.find(current_language)
	var next_id = (id + 1) % Language_id.size()
	
	TranslationServer.set_locale(Language_id[next_id])