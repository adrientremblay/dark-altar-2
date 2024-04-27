extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
		
	body.collect_skull()
	queue_free()
