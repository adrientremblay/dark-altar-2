extends Node3D

var shaderMat : ShaderMaterial
var choirSound: AudioStreamPlayer

@onready var ui = $UI

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	choirSound = $Choir
	$Cedric.increase_agression($Cedric/TeleportTimer)

func _process(delta: float) -> void:
	var angle_to_cedric = abs($Player.check_if_can_see_me($Cedric))
	
	var distance_to_cedric_vec = $Player.global_position - $Cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	
	var ghost = 0
	var amplitude = 0.01
	if (angle_to_cedric < 75 && distance_to_cedric <= 15):
		var angle_scale = ((75 - angle_to_cedric) / 75) * 0.5
		var distance_scale = ((15 - distance_to_cedric) / 15) * 0.5
		var damage_scale = angle_scale + distance_scale
		$Player.health -= damage_scale * 30 * delta
	elif $Player.health < 100:
		$Player.health += 20 * delta
	
	if $Player.health < 0:
		get_tree().change_scene_to_file("res://death_screen.tscn")
	if $Player.health < 100:
		var distortion_scale = (100 - $Player.health) / 100
		ghost = distortion_scale * 0.7
		choirSound.volume_db = (1 - distortion_scale) * -40
		
		if (!choirSound.playing):
			choirSound.play()
			
	if choirSound.volume_db < -40:
		choirSound.stop()
	
	shaderMat.set_shader_parameter("ghost", ghost)
	shaderMat.set_shader_parameter("amplitude", amplitude)

func _on_teleport_timer_timeout() -> void:
	var angle_to_cedric = abs($Player.check_if_can_see_me($Cedric))
	
	var distance_to_cedric_vec = $Player.global_position - $Cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	
	var ghost = 0
	var amplitude = 0.01
	if (angle_to_cedric < 75 && distance_to_cedric <= 10):
		return
	
	var player_position = $Player.position
	$Cedric.teleport(player_position)


func _on_player_register_skull() -> void:
	$Cedric.increase_agression($Cedric/TeleportTimer)

func _input(event):
	if event.is_action_pressed("interact"):
		var interactable : Area3D = $Player.return_interactable()
		if interactable == null:
			return
		
		if interactable.is_in_group("page"):
			$Player.reading = not $Player.reading
			var page: Page = interactable
			ui.display_page(page)
			
		if interactable.is_in_group("skull"):
			var skull = interactable
			$Player.collect_skull()
			skull.queue_free()
