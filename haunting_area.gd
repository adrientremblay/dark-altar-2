extends Area3D

signal start_haunting
signal stop_haunting

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		start_haunting.emit()
		$EnterSound.play()
		
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		stop_haunting.emit()
		$EnterSound.play()
