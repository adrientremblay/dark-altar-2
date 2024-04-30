extends Node3D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var children = self.get_children()
	
	var keep_index = rng.randi_range(0, children.size() - 1)
	for i in range(children.size()):
		var child = children[i]
		if i == keep_index:
			child.visible = true
		else:
			child.queue_free()
