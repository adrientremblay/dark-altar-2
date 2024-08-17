class_name SkullGroup extends Node3D

func _init(keep_index: int) -> void:
	var children = self.get_children()
	for i in range(children.size()):
		var child = children[i]
		if i == keep_index:
			child.visible = true
		else:
			child.queue_free()
