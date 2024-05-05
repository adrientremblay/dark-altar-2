extends CharacterBody3D

var random = RandomNumberGenerator.new()

var can_boom = false
var distance_to_spawn = 50
var agression = 0
var disabled = false
var can_move = true

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	if disabled or not can_move:
		return
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * 2, 10 * delta)
	
	move_and_slide()
	
func increase_agression(timer : Timer):
	agression += 1
	change_agression(agression, timer)

func change_agression(agression: int, timer : Timer):
	match agression:
		1:
			distance_to_spawn = 20 # TODO Time to spawn
			timer.wait_time = 15
		2:
			distance_to_spawn = 10
			timer.wait_time = 15
		3:
			distance_to_spawn = 10
		4:
			distance_to_spawn = 8

func teleport(player: Player):
	return
	var player_position = player.position
	
	var safe_distance = min(player.candle_light.omni_range + 1, distance_to_spawn)
	
	# move
	var random_direction = Vector3(random.randf_range(-1, 1), 0, random.randf_range(-1, 1)).normalized()
		
	var random_distance_vector = random_direction * safe_distance
	
	position = player_position + random_distance_vector
	
	# rotate
	var direction_to = position.direction_to(player_position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis
	
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
	
