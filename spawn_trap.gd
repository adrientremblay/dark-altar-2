extends Area3D

@export var teleport_target: Node3D
@export var cedric: Cedric

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cedric.global_position = teleport_target.global_position + Vector3(0, 0.83, 0)
		print("TPing cedric to " + str (teleport_target.global_position))
