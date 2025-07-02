class_name Door extends Area3D

var locked = true

func open():
	if !locked:
		$AnimationPlayer.play("open")
		$OpenSound.play()
	else:
		$AnimationPlayer.play("locked")
		$LockedSound.play()
