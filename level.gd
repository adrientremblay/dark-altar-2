class_name Level extends Node3D

@export var skull_group: SkullGroup
signal skull_collected

func init(skull_keep_index: int):
	if skull_group:
		skull_group.init(skull_keep_index)
