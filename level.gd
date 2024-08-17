class_name Level extends Node3D

@export var skull_group: SkullGroup

func init(skull_keep_index: int):
	if skull_group:
		skull_group._init(skull_keep_index)
