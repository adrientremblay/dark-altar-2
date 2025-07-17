class_name DoorWrapper extends Node3D

@export var door_name: String

func unlock():
	$"Church Door/Door1".locked = false

func slam():
	$"Church Door/Door1".close()
