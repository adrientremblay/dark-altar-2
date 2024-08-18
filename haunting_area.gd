extends Area3D

signal haunting_area_entered
signal haunting_area_exited

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		haunting_area_entered.emit()
		$EnterSound.play()
		
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		haunting_area_exited.emit()
		$EnterSound.play()
