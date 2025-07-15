class_name Dialogue extends AudioStreamPlayer

var played = false
@export var transcript: String

func play_once():
	if played:
		return
	
	play()
	played = true
