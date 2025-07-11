extends Area3D

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	var anim: Animation = animation_player.get_animation("move_arrow")
	anim.loop_mode = Animation.LOOP_PINGPONG
	animation_player.play("move_arrow")
