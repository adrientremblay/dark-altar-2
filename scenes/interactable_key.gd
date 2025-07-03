class_name Key extends Area3D

@export var door : DoorWrapper
@export var message : String

func pickup():
	door.unlock()
	queue_free()
