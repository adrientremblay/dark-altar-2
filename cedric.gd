extends CharacterBody3D

var random = RandomNumberGenerator.new()

func teleport(player_position):
	# move
	var random_distance_vector = Vector3(random.randf_range(-2, 2), 0, random.randf_range(-2, 2))
	position = player_position + random_distance_vector
	
	# rotate
	var basis_x = transform.basis.x
	var direction_to_player = position.direction_to(player_position)
	print("direction_to_player: ", direction_to_player)
	print("basis_x: ", basis_x)
	var angle_to_rotate = rad_to_deg(basis_x.angle_to(direction_to_player))
	print("angle to rotate: ", angle_to_rotate)
	rotation.y = angle_to_rotate
