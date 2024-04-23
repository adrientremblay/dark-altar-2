extends Node3D


func _on_teleport_timer_timeout() -> void:
	var player_position = $Player.position
	$Cedric.teleport(player_position)
	$Player.check_if_can_see_me($Cedric.position)
