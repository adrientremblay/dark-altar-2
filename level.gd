class_name Level extends Node3D

@export var skull_group: SkullGroup
@export var cross_group: SkullGroup
@export var key_group: Key
signal skull_collected

func init(skull_keep_index: int, cross_keep_index: int = 0):
	if skull_group:
		skull_group.init(skull_keep_index)
	if cross_group:
		cross_group.init(cross_keep_index)
