class_name SkullPlacer extends Area3D

@onready var animation_player = $AnimationPlayer
@onready var arrow = $butt_plug
@onready var skull = $SkullModel
@onready var place_skull_sound = $AudioStreamPlayer3D

var disabled = false

func _ready() -> void:
	var anim: Animation = animation_player.get_animation("move_arrow")
	anim.loop_mode = Animation.LOOP_PINGPONG
	animation_player.play("move_arrow")

func show_skull() -> void:
	if disabled:
		return
	
	animation_player.stop()
	arrow.visible = false
	skull.visible = true
	disabled = true
	place_skull_sound.play()
