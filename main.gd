extends Node3D

var shaderMat : ShaderMaterial
var choirSound: AudioStreamPlayer

@onready var ui = $UI
@onready var cedric: Cedric = $Cedric
@onready var player: Player = $Player

var CEDRIC_DAMAGE_DISTANCE = 10
var CEDRIC_DAMAGE = 30

var haunting = false
var skulls_found = 0

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	choirSound = $Choir
	cedric.player = $Player
	
func _physics_process(delta: float) -> void:
	cedric.act_based_on_mode($Player)

func _process(delta: float) -> void:
	if Global.game_paused:
		return
	
	var angle_to_cedric = abs($Player.check_if_can_see_me(cedric))
	
	var distance_to_cedric_vec = $Player.global_position - cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	
	var ghost = 0
	var amplitude = 0.01
	if (distance_to_cedric <= CEDRIC_DAMAGE_DISTANCE):
		var damage_scale = (CEDRIC_DAMAGE_DISTANCE - distance_to_cedric) / CEDRIC_DAMAGE_DISTANCE
		$Player.sanity -= damage_scale * CEDRIC_DAMAGE * delta
	elif $Player.sanity < 100:
		$Player.sanity += 20 * delta
	
	if $Player.sanity < 0:
		$Player.sanity = 0
		get_tree().change_scene_to_file("res://death_screen.tscn")
	if $Player.sanity < 100:
		var distortion_scale = (100 - $Player.sanity) / 100
		ghost = distortion_scale * 0.7
		choirSound.volume_db = (1 - distortion_scale) * -40
		
		if (!choirSound.playing):
			choirSound.play()
			
	if choirSound.volume_db < -40:
		choirSound.stop()
	
	shaderMat.set_shader_parameter("ghost", ghost)
	shaderMat.set_shader_parameter("amplitude", amplitude)
	
	if haunting:
		cedric.change_agression(delta)

func _on_player_register_skull() -> void:
	#cedric.increase_agression($Cedric/TeleportTimer)
	pass

func _input(event):
	if event.is_action_pressed("interact"):
		var interactable : Area3D = $Player.return_interactable()
		if interactable == null:
			return
		
		if interactable.is_in_group("page"):
			$Player.reading = not $Player.reading
			var page: Page = interactable
			ui.display_page(page)	
			if not $Player.reading:
				unpause()
			else:
				pause()
		elif interactable.is_in_group("skull"):
			var skull = interactable
			skulls_found += 1
			$Player.collect_skull(skulls_found)
			skull.queue_free()
		elif interactable.is_in_group("candle"):
			var candle = interactable
			$Player.collect_candle()
			candle.queue_free()
	elif event.is_action_pressed("pause"):
		Global.game_paused = not Global.game_paused
		if Global.game_paused:
			pause()
		else:
			unpause()

func _on_haunting_area_start_haunting() -> void:
	haunting = true
	cedric.start_haunt()

func _on_haunting_area_stop_haunting() -> void:
	haunting = false
	cedric.stop_haunt()

func pause():
	Global.game_paused = true
	var ambience_bus_index = AudioServer.get_bus_index("Ambience")
	AudioServer.set_bus_volume_db(ambience_bus_index, -100)
	player.pause_flame()
	if not $Player.reading:
		ui.toggle_pause_menu(true)
	
func unpause():
	Global.game_paused = false
	var ambience_bus_index = AudioServer.get_bus_index("Ambience")
	AudioServer.set_bus_volume_db(ambience_bus_index, 0)
	player.unpause_flame()
	if not $Player.reading:
		ui.toggle_pause_menu(false)
