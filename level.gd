class_name Level extends Node3D

@export var skull_group: SkullGroup
signal skull_collected
signal start_haunting
signal stop_haunting

func init(skull_keep_index: int):
	if skull_group:
		skull_group.init(skull_keep_index)

func _on_haunting_area_graveyard_haunting_area_entered() -> void:
	start_haunting.emit()

func _on_haunting_area_graveyard_haunting_area_exited() -> void:
	stop_haunting.emit()
