extends Node3D

func _ready() -> void:
	var shaderMat : ShaderMaterial = $CanvasLayer/ColorRect.material
	shaderMat.set_shader_parameter("ghost", 1.0)

func _process(delta: float) -> void:
	$Player.check_if_can_see_me($Cedric)

func _on_teleport_timer_timeout() -> void:
	var player_position = $Player.position
	$Cedric.teleport(player_position)
