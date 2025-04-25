class_name Skull extends Area3D

@export var level: Level

func _ready():
	$AudioStreamPlayer3D.play()
