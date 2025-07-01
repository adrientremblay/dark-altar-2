extends Node3D

func _input(event):
	if event.is_action_pressed("open_door"):
		$AnimationPlayer.play("open_door")
