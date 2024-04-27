extends Node3D

var shaderMat : ShaderMaterial

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	shaderMat.set_shader_parameter("ghost", 1.0)

func _process(delta: float) -> void:
	var angle_to_cedric = abs($Player.check_if_can_see_me($Cedric))
	
	var ghost = 0
	var amplitude = 0.01
	if (angle_to_cedric < 75):
		ghost = 1
		var distortion_scale = (75 - angle_to_cedric) / 75
		ghost = distortion_scale * 0.5
	
	shaderMat.set_shader_parameter("ghost", ghost)
	shaderMat.set_shader_parameter("amplitude", amplitude)

func _on_teleport_timer_timeout() -> void:
	var player_position = $Player.position
	$Cedric.teleport(player_position)
