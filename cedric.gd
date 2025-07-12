class_name Cedric extends CharacterBody3D

var random = RandomNumberGenerator.new()

var spotted = false
var can_teleport = false
var frozen = false
var vulnerable = false

var agression_level = 0 # corresponds to the number of skulls the player has collected
# The following are indexed by agression_level
const TELEPORT_COOLDOWNS = [100, 30, 15, 10, 7, 5] # the cooldown (s) for cedric's teleport ability is
const TELEPORT_DISTANCE = [100, 25, 20, 15, 10, 5] # the distance added to the safe distance that cedric tps

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var teleport_timer: Timer = $TeleportTimer 
@onready var dialogue: AudioStreamPlayer3D = $DialogueSound

var player: Player

var dungeon_ai_active = false
var disabled = false

@onready var dialogue_1 = preload("res://assets/audio/sound_effects/cedric_dialogue/1.mp3")

signal cedric_has_died

func _process(delta: float) -> void:
	if Global.game_paused :
		return
	
	# always rotate towards player
	var direction_to = position.direction_to(player.position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis
	
	if dungeon_ai_active || disabled:
		return
		
	if can_teleport && not player.check_if_can_see_me(self):
		self.visible = false
		teleport()
		self.visible = true
		spotted_behaviour()
		can_teleport = false
	else:
		spotted_behaviour()

func _physics_process(delta: float) -> void:
	if Global.game_paused || !dungeon_ai_active || disabled || frozen:
		return
	
	nav.target_position = player.position

	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var speed = 150
	velocity = direction * speed * delta
	move_and_slide()

func teleport():
	if Global.game_paused || agression_level < 1 || dungeon_ai_active || disabled:
		return
	
	var safe_distance = min(player.candle_light.omni_range + 1, TELEPORT_DISTANCE[agression_level])
	
	# move
	var random_direction = Vector3(random.randf_range(-1, 1), 0, random.randf_range(-1, 1)).normalized()
	var random_distance_vector = random_direction * safe_distance
	var target_position = player.position + random_distance_vector
	nav.target_position = target_position
	position = target_position
	position = nav.target_position 
	
	$MovementSound.play()
	
	teleport_timer.start()
	
func play_movement_sound():
	$MovementSound.play()

func spotted_behaviour():
	if spotted:
		return
	
	if not player.check_if_can_see_me(self):
		return
	
	# the sound is a bit cheesy so disabling for a sec
	#$BoomSound.play()
	player.start_flame_flicker()
	
	spotted = true

func rotate_to_me(player_position: Vector3):
	# rotate
	var direction_to = position.direction_to(player_position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis

func increase_agression():
	agression_level += 1
	# Update the teleport timer and start it
	teleport_timer.wait_time = TELEPORT_COOLDOWNS[agression_level]
	teleport_timer.start()

func _on_haunt_change_position_timer_timeout() -> void:
	can_teleport = true
	spotted = false

func play_dialogue(dialogue_number: int):
	return
	match dialogue_number:
		1:
			dialogue.stream = dialogue_1
	dialogue.play()

func _on_area_3d_slam_door_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		dungeon_ai_active = true

func _disable_cedric_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		disabled = true

func _disable_cedric_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")):
		disabled = false

var death_seq_active = false
func _on_holy_ball_detector_area_entered(area: Area3D) -> void:
	if (area.is_in_group("holy")):
		if vulnerable:
			$ImpactSound.play()
			if !death_seq_active:
				startDeathCountdown()
		else:
			$ImpactSound.play()
			frozen = true
			$UnfreezeTimer.start()
		area.queue_free()

func _on_unfreeze_timer_timeout() -> void:
	frozen = false
	
func playTpSound() -> void:
	$MovementSound.play()
	
func startDeathCountdown() -> void:
	print("Start death timer")
	$DeathTimer.start()
	death_seq_active = true

func _on_death_timer_timeout() -> void:
	$DeathSound.play()
	global_position = Vector3(0,0,0)
	cedric_has_died.emit()
