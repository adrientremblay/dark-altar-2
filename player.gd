class_name Player extends CharacterBody3D

@export var speed = 3.5
@export var sprint_modifier = 1.7
var sprint_regen = 10
var sprint_degen = 30
enum MovementMode {STANDING, WALKING, SPRINTING}
var movement_mode : MovementMode = MovementMode.STANDING

@onready var neck = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var particle_emitter : GPUParticles3D = $CameraPivot/Camera3D/Candle/Flame
@onready var grab_shape : Area3D = $CameraPivot/Camera3D/GrabShape
@onready var candle_light : OmniLight3D = $CameraPivot/Camera3D/Candle/WorldLight
@onready var candle = $CameraPivot/Camera3D/Candle

var sanity = 100 # out of 100
var stamina = 100 # out of 100

var camera_max_angle = 80
var camera_min_angle = -80

signal register_skull
signal can_interact_with_something
signal cannot_interact_with_something

var reading = false

func calculate_flame_direction(direction: Vector3):
	var flame_direction : Vector3 = Vector3(0,1,0) # -z
	flame_direction = flame_direction.rotated(Vector3(-1, 0, 0), camera.rotation.x)
	flame_direction -= direction
	particle_emitter.process_material.direction = flame_direction.normalized()

func _unhandled_input(event: InputEvent):
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
	if reading:
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
	
	# movement
	var dp = 0
	if movement_mode == MovementMode.SPRINTING:
		dp = direction * speed * delta * sprint_modifier
	elif movement_mode == MovementMode.WALKING:
		dp = direction * speed * delta
	
	if dp:
		position += dp
	
	calculate_flame_direction(input_dir.normalized())
	move_and_slide()

func change_movement_mode(new_movement_mode : MovementMode):
	match movement_mode:
		MovementMode.STANDING:
			match new_movement_mode:
				MovementMode.WALKING:
					$Walking.play()
				MovementMode.SPRINTING:
					$Sprinting.play()
		MovementMode.WALKING:
			match new_movement_mode:
				MovementMode.STANDING:
					$Walking.stop()
				MovementMode.SPRINTING:
					$Walking.stop()
					$Sprinting.play()
		MovementMode.SPRINTING:
			match new_movement_mode:
				MovementMode.STANDING:
					$Sprinting.stop()
				MovementMode.WALKING:
					$Sprinting.stop()
					$Walking.play()
	
	movement_mode = new_movement_mode

func check_if_can_see_me(cedric: CharacterBody3D):
	var player_direction = (transform.basis * neck.transform.basis * Vector3(0, 0, -1)).normalized()
	var direction_to_cedric = position.direction_to(cedric.position)
	var angle_to_me = rad_to_deg(player_direction.signed_angle_to(direction_to_cedric, Vector3(0,1,0)))
	
	if abs(angle_to_me) <= 75:
		cedric.can_move = false
	else:
		cedric.can_move = true
		
	cedric.rotate_to_me(self.position) # TODO: move
	
	return angle_to_me

func collect_skull():
	register_skull.emit()
	$SkullPickupSound.play()

func _on_grab_shape_area_entered(area: Area3D) -> void:
	can_interact_with_something.emit()

func _on_grab_shape_area_exited(area: Area3D) -> void:
	cannot_interact_with_something.emit()

func return_interactable():
	for area in grab_shape.get_overlapping_areas():
		if area.is_in_group("interactable"):
			return area
	return null
			
func collect_candle():
	candle.replenish()
	$CandlePickupSound.play()
