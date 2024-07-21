extends Node

var in_dungeon = false

func _on_gate_to_hell_body_exited(body: Node3D) -> void:
	in_dungeon = not in_dungeon
	
	if (in_dungeon):
		$DungeonAmbience.play()
		$NightBugs.stop()
		
		$Cricket.enabled = false
		$Owl.enabled = false
		$NightBird.enabled = false
	else:
		$DungeonAmbience.stop()
		$NightBugs.play()
		
		$Cricket.enabled = true
		$Owl.enabled = true
		$NightBird.enabled = true
