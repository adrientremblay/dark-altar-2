extends Node

func _on_dungeon_audio_switcher_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	$DungeonAmbience.play()
	$NightBugs.stop()
	$WindAmbience.stop()
	
	$Cricket.enabled = false
	$Owl.enabled = false
	$NightBird.enabled = false

func _on_outside_audio_switcher_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	$DungeonAmbience.stop()
	$NightBugs.play()
	$WindAmbience.stop()
	
	$Cricket.enabled = true
	$Owl.enabled = true
	$NightBird.enabled = true

func _on_church_audio_switcher_2_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	$DungeonAmbience.stop()
	$NightBugs.stop()
	$WindAmbience.play()
	
	$Cricket.enabled = false
	$Owl.enabled = false
	$NightBird.enabled = false
