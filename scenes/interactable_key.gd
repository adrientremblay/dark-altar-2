class_name Key extends Area3D

@export var door : DoorWrapper

func pickup():
	door.unlock()
	queue_free()
