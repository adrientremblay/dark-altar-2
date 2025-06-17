extends Node3D

func fire():
	$MainEnergyCylinder.emitting = true
	$Timer.start()

func _on_timer_timeout() -> void:
	$MainEnergyCylinder.emitting = false
