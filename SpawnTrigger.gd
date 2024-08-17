extends Area3D

var spawned_level

@export var level: PackedScene

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		spawned_level = level.instantiate()
		add_child(spawned_level)

func _on_body_exited(body: Node3D) -> void:
	if spawned_level:
		spawned_level.queue_free()
		spawned_level = null
