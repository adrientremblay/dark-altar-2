extends CharacterBody3D

var random = RandomNumberGenerator.new()

var can_boom = false

func teleport(player_position):
	# move
	var random_distance_vector = Vector3(random.randf_range(-2, 2), 0, random.randf_range(-2, 2))
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
