extends Control

var intro_label = 1

func _on_intro_timer_timeout() -> void:
	match intro_label:
		1:
			$IntroTimer.stop()
			$Label.visible = false
	intro_label +=1

func _on_player_register_skull() -> void:
	intro_label = 1
	$IntroTimer.start()
	$Label.text = "skull collected"
	$Label.visible = true


func _on_player_can_interact_with_something() -> void:
	$InteractHand.visible = true

func _on_player_cannot_interact_with_something() -> void:
	$InteractHand.visible = false
