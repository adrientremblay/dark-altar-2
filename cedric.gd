class_name Cedric extends CharacterBody3D

var random = RandomNumberGenerator.new()

var spotted = true

var agression_level = 0 # corresponds to the number of skulls the player has collected
# The following are indexed by agression_level
const TELEPORT_COOLDOWNS = [100, 30, 15, 10, 7, 5] # the cooldown (s) for cedric's teleport ability is
const TELEPORT_DISTANCE = [100, 25, 20, 15, 10, 5] # the distance added to the safe distance that cedric tps

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var teleport_timer: Timer = $TeleportTimer 

var player: Player

var dungeon_ai_active = false

func _process(delta: float) -> void:
	if Global.game_paused:
		return
	
	# always rotate towards player
	var direction_to = position.direction_to(player.position)
	var new_basis = Basis.looking_at(direction_to)
	basis = new_basis
	
	# flickering when cedric is first spotted after he TPs
	spotted_behaviour()

func _physics_process(delta: float) -> void:
	if Global.game_paused:
		return
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var speed = 100
	velocity = velocity.lerp(direction * 10, speed * delta)
	move_and_slide()

func teleport():
	if Global.game_paused || agression_level < 1 || dungeon_ai_active:
		return
	
	if (player.check_if_can_see_me(self)):
		spotted = false # trigger a flicker
	
	var safe_distance = min(player.candle_light.omni_range + 1, TELEPORT_DISTANCE[agression_level])
	
	# move
	var random_direction = Vector3(random.randf_range(-1, 1), 0, random.randf_range(-1, 1)).normalized()
	var random_distance_vector = random_direction * safe_distance
	var target_position = player.position + random_distance_vector
	nav.target_position = target_position
	position = target_position
	position = nav.target_position 
	
	$MovementSound.play()
	
	spotted = false
	
	teleport_timer.start()

func spotted_behaviour():
	if spotted || dungeon_ai_active:
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
	teleport()

func _on_area_to_disable_cedric_normal_ai_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		dungeon_ai_active = ! dungeon_ai_active
		print("dungeon ai active: " + str(dungeon_ai_active))
