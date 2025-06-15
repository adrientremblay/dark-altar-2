extends Area3D

@export var teleport_target: Node3D
@export var cedric: Cedric
@export var dialogue_number: int

var used = false

func _on_body_entered(body: Node3D) -> void:
	if used:
		return
	
	if body.is_in_group("player"):
		cedric.global_position = teleport_target.global_position + Vector3(0, 0.83, 0)
		cedric.play_movement_sound()
		cedric.spotted = false
		
		$Timer.start()
		
		# So that the spawn only happens once
		used = true

func _on_timer_timeout() -> void:
	# tp cedric to the middle of nowhere
	cedric.global_position = Vector3(0,0,0)
	cedric.player.start_flame_flicker()
	cedric.play_movement_sound()
