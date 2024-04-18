extends CharacterBody3D

@export var speed = 20

@onready var neck = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			neck.rotate_x(-event.relative.y * 0.01)

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_forward"):
		position.z -= speed * delta
	if Input.is_action_pressed("move_back"):
		position.z += speed * delta
		
	
