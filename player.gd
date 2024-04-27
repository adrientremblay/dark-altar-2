extends CharacterBody3D

@export var speed = 5

@onready var neck = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

var walking = true
var health = 100 # out of 100

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(60))

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	
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
	
	if (direction):
		position += direction * speed * delta
		if not walking:
			$Footsteps.play()
		walking = true
	else:
		if walking:
			$Footsteps.stop()
		walking = false
	
	move_and_slide()


func _on_dialog_detector_area_entered(area: Area3D) -> void:
	if area.is_in_group("skull"):
		print("skull")

func check_if_can_see_me(cedric: CharacterBody3D):
	var player_direction = (transform.basis * neck.transform.basis * Vector3(0, 0, -1)).normalized()
	var direction_to_cedric = position.direction_to(cedric.position)
	var angle_to_me = rad_to_deg(player_direction.signed_angle_to(direction_to_cedric, Vector3(0,1,0)))
	
	if abs(angle_to_me) <= 75:
		cedric.play_boom()
	else:
		cedric.rotate_to_me(self.position)
	
	return angle_to_me
