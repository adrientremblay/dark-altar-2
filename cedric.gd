class_name Cedric extends CharacterBody3D

var random = RandomNumberGenerator.new()

var can_boom = false
var haunt_distance_min = 5
var haunt_distance_max = 30
var stalking_distance = 30
var agression = 0
var disabled = false
var can_move = true

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var spotted_timer: Timer = $SpottedTimer
@onready var haunt_timer: Timer = $HauntChangePositionTimer
@onready var whispering: AudioStreamPlayer = $Whispering

enum CEDRIC_MODE {STALKING, HAUNTING, CHASING} 

var cedric_mode: CEDRIC_MODE = CEDRIC_MODE.STALKING
var player: Player

var AGRESSION_COEFF = 5

func _physics_process(delta: float) -> void:
	if disabled or not can_move or Global.game_paused:
		return
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var speed
	if cedric_mode == CEDRIC_MODE.STALKING:
		speed = 10
	else:
		speed = 100
	
	velocity = velocity.lerp(direction * 10, speed * delta)
	
	move_and_slide()

func teleport(player: Player):
	position = nav.target_position 
	
	# sound
	can_boom = true

func play_boom():
	if not can_boom:
		return
	
	$BoomSound.play()
	
	can_boom = false

func rotate_to_me(player_position: Vector3):
	# rotate
	var direction_to = position.direction_to(player_position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis
	
func act_based_on_mode(player: Player):
	if Global.game_paused:
		return
	
	match cedric_mode:
		CEDRIC_MODE.STALKING:
			stalk(player)

func stalk(player: Player):
	# Cedric will keep distance from player
	var safe_distance = player.candle_light.omni_range + 1
	var distance = max(safe_distance, stalking_distance)
	var difference_direction = -player.get_player_direction()
	$NavigationAgent3D.target_position = player.global_position + (difference_direction * distance)
	
	# Checking if player can see me
	var angle_to_cedric = abs(player.check_if_can_see_me(self))
	if angle_to_cedric <= 75:
		can_move = false
		if spotted_timer.is_stopped():
			self.player = player
			spotted_timer.start()
	else:
		can_move = true

func _on_spotted_timer_timeout() -> void:
	teleport(player)
	spotted_timer.stop()

func start_haunt():
	spotted_timer.stop()
	cedric_mode = CEDRIC_MODE.HAUNTING
	#whispering.play()
	whispering.volume_db = -10.0
	haunt_timer.start()
	
func stop_haunt():
	#whispering.stop()
	agression = 0
	cedric_mode = CEDRIC_MODE.STALKING
	haunt_timer.stop()

func change_agression(delta: float):
	agression += delta * AGRESSION_COEFF
	agression = min(agression, 100)
	
	whispering.volume_db = -10.0 + (agression * 0.1)
	
func haunt(player: Player):
	var player_position = player.position
	
	var distance_to_spawn = (100 - agression) * 0.01 * (haunt_distance_max - haunt_distance_min) + haunt_distance_min
	var safe_distance = min(player.candle_light.omni_range + 1, distance_to_spawn)
	
	# move
	var random_direction = Vector3(random.randf_range(-1, 1), 0, random.randf_range(-1, 1)).normalized()
	var random_distance_vector = random_direction * safe_distance
	var target_position = player_position + random_distance_vector
	nav.target_position = target_position
	position = target_position
	
	# rotate
	var direction_to = position.direction_to(player_position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis

func _on_haunt_change_position_timer_timeout() -> void:
	#var angle_to_cedric = abs(player.check_if_can_see_me(self))
	#if angle_to_cedric > 75:
	haunt(player)
