extends Node3D

var shaderMat : ShaderMaterial
var choirSound: AudioStreamPlayer

@onready var ui = $UI
@onready var cedric: Cedric = $Cedric

var CEDRIC_DAMAGE_DISTANCE = 10
var CEDRIC_DAMAGE = 30

var haunting = false

func _ready() -> void:
	shaderMat  = $CanvasLayer/ColorRect.material
	choirSound = $Choir
	cedric.player = $Player
	
func _physics_process(delta: float) -> void:
	cedric.act_based_on_mode($Player)

func _process(delta: float) -> void:
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
	#	get_tree().change_scene_to_file("res://death_screen.tscn")
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
	cedric.increase_agression($Cedric/TeleportTimer)

func _input(event):
	if event.is_action_pressed("interact"):
		var interactable : Area3D = $Player.return_interactable()
		if interactable == null:
			return
		
		if interactable.is_in_group("page"):
			$Player.reading = not $Player.reading
			var page: Page = interactable
			ui.display_page(page)	
		elif interactable.is_in_group("skull"):
			var skull = interactable
			$Player.collect_skull()
			skull.queue_free()
		elif interactable.is_in_group("candle"):
			var candle = interactable
			$Player.collect_candle()
			candle.queue_free()

func _on_haunting_area_start_haunting() -> void:
	haunting = true
	cedric.start_haunt()

func _on_haunting_area_stop_haunting() -> void:
	haunting = false
	cedric.stop_haunt()
