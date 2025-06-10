extends Area3D

@export var teleport_target: Node3D
@export var cedric: Cedric
@export var dialogue_number: int

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cedric.global_position = teleport_target.global_position + Vector3(0, 0.83, 0)
		cedric.play_movement_sound()
		cedric.spotted = false
		
		print("TPing cedric to " + str (teleport_target.global_position))
		
		# Make cedric play the relevant creepy voice line
		cedric.play_dialogue(dialogue_number)
		
		# So that the spawn only happens once
		self.queue_free()
