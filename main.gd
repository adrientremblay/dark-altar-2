extends Node3D

var shaderMat : ShaderMaterial
var choirSound: AudioStreamPlayer

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	choirSound = $Choir

func _process(delta: float) -> void:
	var angle_to_cedric = abs($Player.check_if_can_see_me($Cedric))
	
	var distance_to_cedric_vec = $Player.global_position - $Cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	
	var ghost = 0
	var amplitude = 0.01
	if (angle_to_cedric < 75 && distance_to_cedric <= 10):
		var angle_scale = ((75 - angle_to_cedric) / 75) * 0.5
		var distance_scale = ((10 - distance_to_cedric) / 10) * 0.5
		var damage_scale = angle_scale + distance_scale
		$Player.health -= damage_scale * 1.0
		
	if $Player.health < 100:
		var distortion_scale = (100 - $Player.health) / 100
		ghost = distortion_scale * 0.7
		
		if (!choirSound.playing):
			choirSound.play()
	elif (choirSound.playing):
		choirSound.stop()
	
	shaderMat.set_shader_parameter("ghost", ghost)
	shaderMat.set_shader_parameter("amplitude", amplitude)

func _on_teleport_timer_timeout() -> void:
	var player_position = $Player.position
	$Cedric.teleport(player_position)
