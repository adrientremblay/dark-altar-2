class_name Player extends CharacterBody3D

@export var speed = 3.5
@export var sprint_modifier = 1.7
var sprint_regen = 10
var sprint_degen = 30
enum MovementMode {STANDING, WALKING, SPRINTING}
var movement_mode : MovementMode = MovementMode.STANDING
var in_dungeon = false

@onready var neck = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var hand_camera = $CanvasLayer/SubViewportContainer/SubViewport/Camera3D
@onready var particle_emitter : GPUParticles3D = $CameraPivot/Camera3D/Candle/Flame
@onready var grab_shape : Area3D = $CameraPivot/Camera3D/GrabShape
@onready var candle_light : OmniLight3D = $CameraPivot/Camera3D/Candle/WorldLight
@onready var candle = $CameraPivot/Camera3D/Candle
@onready var animation_player : AnimationPlayer = $CameraPivot/Camera3D/AnimationPlayer
@onready var walking : AudioStreamPlayer = $Walking
@onready var sprinting : AudioStreamPlayer = $Sprinting
@onready var crucifix_animation_player : AnimationPlayer = $CameraPivot/Camera3D/LeftArm/CrucifixAnimationPlayer

var sanity = 100 # out of 100
var stamina = 100 # out of 100

var camera_max_angle = 80
var camera_min_angle = -80

signal register_skull(skulls_found: int)
signal can_interact_with_something
signal cannot_interact_with_something

var reading = false

func _ready() -> void:
	#var main_env = camera.get_camera_projection()
	#hand_camera.get_camera_projection().set
	pass

func calculate_flame_direction(direction: Vector3):
	var flame_direction : Vector3 = Vector3(0,1,0) # -z
	flame_direction = flame_direction.rotated(Vector3(-1, 0, 0), camera.rotation.x)
	flame_direction -= direction
	particle_emitter.process_material.direction = flame_direction.normalized()

func _unhandled_input(event: InputEvent):
	if Global.game_paused:
		return
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(camera_min_angle), deg_to_rad(camera_max_angle))

func _physics_process(delta):
	if reading or Global.game_paused:
		return
	
	var input_dir = Vector3.ZERO
	
	# direction
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if not is_on_floor():
		input_dir.y -= 1
	var direction = (transform.basis * neck.transform.basis * input_dir).normalized()
	
	# movement mode code
	if Input.is_action_just_pressed("sprint") and stamina > 0 and direction:
		change_movement_mode(MovementMode.SPRINTING)
	if Input.is_action_just_released("sprint") and stamina > 0:
		if direction:
			change_movement_mode(MovementMode.WALKING)
		else:
			change_movement_mode(MovementMode.STANDING)
	
	if movement_mode == MovementMode.SPRINTING:
		if stamina > 0:
			stamina -= delta * sprint_degen
		else:
			if direction:
				change_movement_mode(MovementMode.WALKING)
			else:
				change_movement_mode(MovementMode.STANDING)
			$Panting.play()
	elif stamina < 100: # TODO: Increased stamina gain if standing
		stamina += delta * sprint_regen
		
	if movement_mode == MovementMode.STANDING and direction:
		change_movement_mode(MovementMode.WALKING)
		
	if movement_mode == MovementMode.WALKING and not direction:
		change_movement_mode(MovementMode.STANDING)
		animation_player.stop()
	
	# movement
	var move_speed = speed
	if movement_mode == MovementMode.SPRINTING:
		move_speed *= sprint_modifier
	
	if direction != Vector3.ZERO:
		velocity = direction * move_speed
	else:
		velocity = Vector3.ZERO
		
	# TODO Fix this with the seperate hand draw layer
	#animation_player.play("Head Bob")
	
	move_and_slide()
	calculate_flame_direction(input_dir.normalized())

func change_movement_mode(new_movement_mode : MovementMode):
	match movement_mode:
		MovementMode.STANDING:
			match new_movement_mode:
				MovementMode.WALKING:
					walking.play()
				MovementMode.SPRINTING:
					sprinting.play()
		MovementMode.WALKING:
			match new_movement_mode:
				MovementMode.STANDING:
					walking.stop()
				MovementMode.SPRINTING:
					walking.stop()
					sprinting.play()
		MovementMode.SPRINTING:
			match new_movement_mode:
				MovementMode.STANDING:
					sprinting.stop()
				MovementMode.WALKING:
					sprinting.stop()
					walking.play()
	
	movement_mode = new_movement_mode

func check_if_can_see_me(cedric: CharacterBody3D):
	# FOV check
	var player_direction = (transform.basis * neck.transform.basis * Vector3(0, 0, -1)).normalized()
	var direction_to_cedric = position.direction_to(cedric.position)
	var angle_to_me = rad_to_deg(player_direction.signed_angle_to(direction_to_cedric, Vector3(0,1,0)))
	if abs(angle_to_me) > 75:
		return false
	
	# Distance check
	var distance_to_cedric_vec = self.global_position - cedric.global_position
	var distance_to_cedric = distance_to_cedric_vec.length()
	var candle_light_range = self.candle_light.omni_range;
	if (distance_to_cedric > candle_light_range):
		return false
	
	# Ray trace check
	var space_state = get_world_3d().direct_space_state
	var ray_trace_obj = PhysicsRayQueryParameters3D.new()
	ray_trace_obj.from = neck.global_position
	ray_trace_obj.to = cedric.global_position
	var ray_trace_result = space_state.intersect_ray(ray_trace_obj)
	var ray_trace_collider = ray_trace_result.collider
	if ray_trace_collider != cedric:
		return false
	
	return true

func get_player_direction():
	var player_direction = (transform.basis * neck.transform.basis * Vector3(0, 0, -1)).normalized()
	return player_direction

func collect_skull(skulls_found: int):
	register_skull.emit(skulls_found)
	$SkullPickupSound.play()

func _on_grab_shape_area_entered(area: Area3D) -> void:
	if area.is_in_group("interactable"):
		can_interact_with_something.emit()

func _on_grab_shape_area_exited(area: Area3D) -> void:
	if area.is_in_group("interactable"):
		cannot_interact_with_something.emit()

func return_interactable():
	for area in grab_shape.get_overlapping_areas():
		if area.is_in_group("interactable"):
			return area
	return null
			
func collect_candle():
	candle.replenish()
	$CandlePickupSound.play()

func pause_flame():
	particle_emitter.speed_scale = 0
	
func unpause_flame():
	particle_emitter.speed_scale = 1

func _process(delta: float) -> void:
	hand_camera.global_transform = camera.global_transform

func _on_gate_to_hell_body_exited(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	in_dungeon = not in_dungeon
	
	if movement_mode == MovementMode.WALKING:
		if (in_dungeon):
			walking.stop()
			walking = $StoneWalking
			sprinting = $StoneSprinting
			walking.play()
		else:
			walking.stop()
			walking = $Walking
			sprinting = $Sprinting
			walking.play()
	else:
		if (in_dungeon):
			sprinting.stop()
			sprinting = $StoneSprinting
			walking = $StoneWalking
			sprinting.play()
		else:
			sprinting.stop()
			sprinting = $Sprinting
			walking = $Walking
			sprinting.play()

func start_flame_flicker():
	candle.flickering = true
	$FlameFlickerTimer.start()
	$FlameFlickerSound.play()

func _on_flame_flicker_timer_timeout() -> void:
	candle.flickering = false

func _input(event):
	if event.is_action_pressed("rebuke"):
		crucifix_animation_player.play("rebuke")
