extends Area3D

var SPEED = 10.0
var direction = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector3.ZERO:
		global_position += direction * SPEED * delta
