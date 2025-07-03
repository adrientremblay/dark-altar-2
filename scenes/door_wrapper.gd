class_name DoorWrapper extends Node3D

func unlock():
	$"Church Door/Door1".locked = false

func slam():
	$"Church Door/Door1".close()
