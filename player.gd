extends CharacterBody3D

@export var speed = 20

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_forward"):
		position.z -= speed * delta
	if Input.is_action_pressed("move_back"):
		position.z += speed * delta
		
	
