extends Area3D

var rng = RandomNumberGenerator.new()
var spawned_level
var skull_keep_index: int

@export var level: PackedScene
@export var number_skull_options: int

func _ready() -> void:
	skull_keep_index = rng.randi_range(0, number_skull_options - 1)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		spawned_level = level.instantiate()
		add_child(spawned_level)

func _on_body_exited(body: Node3D) -> void:
	if spawned_level:
		spawned_level.queue_free()
		spawned_level = null
