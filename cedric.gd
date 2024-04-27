extends CharacterBody3D

var random = RandomNumberGenerator.new()

var can_boom = false
var agression = 1

func teleport(player_position):
	# move
	var random_direction = Vector3(random.randf_range(-1, 1), 0, random.randf_range(-1, 1)).normalized()
	
	var distance_to_spawn = 50
	match agression:
		1:
			distance_to_spawn = 20
		2:
			distance_to_spawn = 15
		3:
			distance_to_spawn = 10
		4:
			distance_to_spawn = 8
		
		
	var random_distance_vector = random_direction * distance_to_spawn
	
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
	
