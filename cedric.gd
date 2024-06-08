class_name Cedric extends CharacterBody3D

var random = RandomNumberGenerator.new()

var can_boom = false
var distance_to_spawn = 50
var agression = 0
var disabled = false
var can_move = true

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var spotted_timer: Timer = $SpottedTimer

enum CEDRIC_MODE {STALKING, HAUNTING, CHASING} 

var cedric_mode: CEDRIC_MODE = CEDRIC_MODE.STALKING
var player: Player

func _physics_process(delta: float) -> void:
	if disabled or not can_move:
		return
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * 5, 10 * delta)
	
	move_and_slide()

func teleport(player: Player):
	position = nav.get_next_path_position()
	
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
	match cedric_mode:
		CEDRIC_MODE.STALKING:
			stalk(player)

func stalk(player: Player):
	# Cedric will keep distance from player
	var safe_distance = player.candle_light.omni_range + 1
	var stalking_distance = distance_to_spawn
	var distance = max(safe_distance, stalking_distance)
	var difference_direction = -player.get_player_direction()
	$NavigationAgent3D.target_position = player.global_position + (difference_direction * distance)
	
	# Checking if player can see me
	
	var angle_to_cedric = abs(player.check_if_can_see_me(self))
	if angle_to_cedric <= 75 and spotted_timer.is_stopped():
		self.player = player
		spotted_timer.start()

func _on_spotted_timer_timeout() -> void:
	teleport(player)
