class_name SkullPlacer extends Area3D

@onready var animation_player = $AnimationPlayer
@onready var arrow = $butt_plug
@onready var skull = $SkullModel

var disabled = false

func _ready() -> void:
	var anim: Animation = animation_player.get_animation("move_arrow")
	anim.loop_mode = Animation.LOOP_PINGPONG
	animation_player.play("move_arrow")

func show_skull() -> void:
	animation_player.stop()
	arrow.visible = false
	skull.visible = true
	disabled = true
