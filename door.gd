class_name Door extends Area3D

func open():
	$AnimationPlayer.play("open")
	$AudioStreamPlayer3D.play()
