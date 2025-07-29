class_name DoorWrapper extends Node3D

@export var door_name: String

func _ready() -> void:
	$"Church Door/Door1".door_name = door_name

func unlock():
	$"Church Door/Door1".locked = false

func slam():
	$"Church Door/Door1".close()
