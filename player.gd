extends CharacterBody3D

@export var speed = 5

@onready var neck = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

var intro_dialog_1 = Dialog.new("res://assets/audio/dialog/intro1.mp3")
var intro_dialog_2 = Dialog.new("res://assets/audio/dialog/intro2.mp3")

var walking = true

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
	if area.name == "Dialog1":
		play_dialog(intro_dialog_1)
	if area.name == "Dialog2":
		play_dialog(intro_dialog_2)

func play_dialog(dialog: Dialog):
	if dialog.was_played:
		return
		
	$Dialog.stream = dialog.audio_file
	$Dialog.play()
		
	dialog.was_played = true
