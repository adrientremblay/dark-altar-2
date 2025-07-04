extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var player: Player

func _physics_process(delta: float) -> void:
	pass
	if Global.game_paused:
		return
		
	nav.target_position = player.global_position
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var speed = 1
	velocity = velocity.lerp(direction * 10, speed * delta)
	print(nav.get_next_path_position())
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("tp"):
		global_position = player.global_position
