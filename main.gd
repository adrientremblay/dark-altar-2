extends Node3D

func _process(delta: float) -> void:
	$Player.check_if_can_see_me($Cedric)

func _on_teleport_timer_timeout() -> void:
	var player_position = $Player.position
	$Cedric.teleport(player_position)
