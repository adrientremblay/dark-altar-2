class_name Door extends Area3D

var locked = true
var disabled = false
var door_name = ''

func open():
	if disabled:
		return
	
	if !locked:
		$AnimationPlayer.play("open")
		$OpenSound.play()
		disabled = true
	else:
		$AnimationPlayer.play("locked")
		$LockedSound.play()

func close():
	$AnimationPlayer.play("close")
	$SlamSound.play()
