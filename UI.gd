extends Control

var intro_label = 1

func _on_intro_timer_timeout() -> void:
	match intro_label:
		1:
			$Label.text = "clease the town"
		2:
			$Label.text = "of cedric leopold"
		3:
			$IntroTimer.stop()
			$Label.visible = false
	intro_label +=1
