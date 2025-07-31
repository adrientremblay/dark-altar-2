extends Area3D

var rng = RandomNumberGenerator.new()
var spawned_level
var skull_keep_index: int
var cross_keep_index: int
var progress = []

@export var level_path: String
@export var number_skull_options: int
@export var number_cross_options: int
@export var cedric: Cedric

func _ready() -> void:
	skull_keep_index = rng.randi_range(0, number_skull_options - 1)
	cross_keep_index = rng.randi_range(0, number_cross_options - 1)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Spawning level")
		ResourceLoader.load_threaded_request(level_path, "PackedScene")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and spawned_level:
		print("Despawning level")
		spawned_level.queue_free()
		spawned_level = null
		
func _on_skull_collected() -> void:
	skull_keep_index = -1
	
func _process(delta: float) -> void:
	if spawned_level:
		return
	
	var result = ResourceLoader.load_threaded_get_status(level_path, progress)
	if result == ResourceLoader.THREAD_LOAD_LOADED:
		print("Finished loading level now adding it")
		var scene_to_load = ResourceLoader.load_threaded_get(level_path)
		spawned_level = scene_to_load.instantiate()
		spawned_level.init(skull_keep_index, cross_keep_index)
		spawned_level.connect("skull_collected", self._on_skull_collected)
		add_child(spawned_level)
	elif result == ResourceLoader.THREAD_LOAD_FAILED:
		print("failed to load level")
