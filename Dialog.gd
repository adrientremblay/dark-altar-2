class_name Dialog extends Node

var audio_file
var was_played = false

func _init(dialog_file_name: String):
	audio_file = load(dialog_file_name)
