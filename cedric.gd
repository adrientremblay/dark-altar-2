extends CharacterBody3D

var random = RandomNumberGenerator.new()

func teleport(player_position):
	var random_distance_vector = Vector3(random.randf_range(1, 2), 0, random.randf_range(1, 2))
	position = player_position + random_distance_vector
	rotate(position, position.angle_to(player_position))
