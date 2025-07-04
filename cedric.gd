class_name Cedric extends CharacterBody3D

var random = RandomNumberGenerator.new()

var spotted = false
var can_teleport = false

var agression_level = 0 # corresponds to the number of skulls the player has collected
# The following are indexed by agression_level
const TELEPORT_COOLDOWNS = [100, 30, 15, 10, 7, 5] # the cooldown (s) for cedric's teleport ability is
const TELEPORT_DISTANCE = [100, 25, 20, 15, 10, 5] # the distance added to the safe distance that cedric tps

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var teleport_timer: Timer = $TeleportTimer 
@onready var dialogue: AudioStreamPlayer3D = $DialogueSound

var player: Player

var dungeon_ai_active = false

@onready var dialogue_1 = preload("res://assets/audio/sound_effects/cedric_dialogue/1.mp3")

func _process(delta: float) -> void:
	if Global.game_paused:
		return
	
	# always rotate towards player
	var direction_to = position.direction_to(player.position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis
	
	if dungeon_ai_active:
		return
		
	if can_teleport && not player.check_if_can_see_me(self):
		teleport()
		can_teleport = false
	
	# flickering when cedric is first spotted after he TPs
	spotted_behaviour()

func _physics_process(delta: float) -> void:
	if Global.game_paused || !dungeon_ai_active:
		return
	
	nav.target_position = player.global_position

	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var speed = 0.1
	velocity = velocity.lerp(direction * 10, speed * delta)
	move_and_slide()

func teleport():
	if Global.game_paused || agression_level < 1 || dungeon_ai_active:
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
