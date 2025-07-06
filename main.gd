extends Node3D

var shaderMat : ShaderMaterial
var choirSound: AudioStreamPlayer

@onready var ui = $UI
@onready var cedric: Cedric = $Cedric
@onready var player: Player = $Player
@onready var church = $church

var CEDRIC_DAMAGE = 100
var PLAYER_HEALING_PER_TICK = 5

var skulls_found = 0
var door_slammed = false

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	choirSound = $Choir
	cedric.player = $Player

func _process(delta: float) -> void:
	if Global.game_paused:
		return
	
	var distance_to_cedric_vec = $Player.global_position - cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	
	var ghost = 0
	var amplitude = 0.01
	if ($Player.check_if_can_see_me(cedric)):
		var damage = (1 / distance_to_cedric) * CEDRIC_DAMAGE * delta
		$Player.sanity -= damage
	elif $Player.sanity < 100:
		$Player.sanity += PLAYER_HEALING_PER_TICK * delta
		#print("Player sanity healing!!! " + str(player.sanity))
	
	if $Player.sanity < 0:
		$Player.sanity = 0
		get_tree().change_scene_to_file("res://death_screen.tscn")
	if $Player.sanity < 100:
		var distortion_scale = (100 - $Player.sanity) / 100
		ghost = distortion_scale * 1.2
		choirSound.volume_db = ((1 - distortion_scale) * -20) + 2
		if (!choirSound.playing):
			choirSound.play()
	elif choirSound.volume_db > -40:
		choirSound.volume_db -= 1
	else:
		choirSound.stop()
	
	shaderMat.set_shader_parameter("ghost", ghost)
	shaderMat.set_shader_parameter("amplitude", amplitude)

func _input(event):
	if event.is_action_pressed("interact"):
		var interactable : Area3D = $Player.return_interactable()
		if interactable == null:
			return
		
		if interactable.is_in_group("page"):
			$Player.reading = not $Player.reading
			var page: Page = interactable
			ui.display_page(page)	
			ui.display_message("")
			if not $Player.reading:
				unpause()
				page.queue_free()
				if page.page_title == "Church Note":
					ui.display_message("Search the village for the five skulls")
			else:
				pause()
		elif interactable.is_in_group("skull"):
			var skull = interactable
			skulls_found += 1
			$Player.collect_skull(skulls_found)
			cedric.increase_agression()
			if skull.level: # the starting skull has no level
				skull.level.skull_collected.emit()
			if skulls_found == 5:
				ui.display_banish_message()
				$ChurchKey.position = skull.position
			skull.queue_free()
		elif interactable.is_in_group("candle"):
			var candle = interactable
			$Player.collect_candle()
			candle.queue_free()
		elif interactable.is_in_group("door"):
			var door: Door = interactable
			door.open()
			if door.locked:
				ui.display_message("You do not possess the key for this door")
		elif interactable.is_in_group("key"):
			var key : Key = interactable
			ui.display_message(key.message)
			key.pickup()
			$PickupSound.play()
		elif interactable.is_in_group("crucifix"):
			$"DungeonKey".global_position = interactable.global_position
			interactable.queue_free()
			ui.display_message("Another key was hidden beneath the crucifix")
			$CrucifixPickupSound.play()
	elif event.is_action_pressed("pause"):
		Global.game_paused = not Global.game_paused
		if Global.game_paused:
			pause()
		else:
			unpause()

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

func _on_intro_timer_timeout() -> void:
	ui.display_message("Read the note")

func _on_area_3d_slam_door_body_entered(body: Node3D) -> void:
	if door_slammed:
		return
	
	if body.is_in_group("player"):
		$DungeonDoor.slam()
		door_slammed = true
		cedric.global_position = $DungeonSpawnPosition.global_position
		ui.display_message("Search for the ritual chamber")
		
var pickup_cross_message_displayed = false
func _on_area_3d_pickup_cross_message_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') and !pickup_cross_message_displayed:
		ui.display_message('Pick up the crucifix')
		pickup_cross_message_displayed = true

func _on_church_audio_switcher_2_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		cedric.global_position = $OutsideDoor.global_position
