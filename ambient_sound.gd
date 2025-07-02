extends Node

@onready var tween1 :Tween
@onready var tween2 :Tween

var MIN_VOLUME = -80 #db
var MAX_VOLUME = 0 #db
var TRANSITION_TIME = 2 #seconds

func _on_dungeon_audio_switcher_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
		
	$DungeonAmbience.play()
	$DungeonAmbience.volume_db = MIN_VOLUME
	var tween1 = get_tree().create_tween().set_parallel(true)
	tween1.tween_property($DungeonAmbience, "volume_db", -15, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$ChurchAmbience.play()
	$ChurchAmbience.volume_db = MAX_VOLUME
	var tween2 = get_tree().create_tween().set_parallel(true)
	tween2.tween_property($ChurchAmbience, "volume_db", MIN_VOLUME, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$NightBugs.stop()

	$Cricket.enabled = false
	$Owl.enabled = false
	$NightBird.enabled = false

func _on_outside_audio_switcher_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	$NightBugs.play()
	$NightBugs.volume_db = MIN_VOLUME
	var tween1 = get_tree().create_tween().set_parallel(true)
	tween1.tween_property($NightBugs, "volume_db", 10, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	$ChurchAmbience.play()
	$ChurchAmbience.volume_db = MAX_VOLUME
	var tween2 = get_tree().create_tween().set_parallel(true)
	tween2.tween_property($ChurchAmbience, "volume_db", MIN_VOLUME, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	$DungeonAmbience.stop()
	
	$Cricket.enabled = true
	$Owl.enabled = true
	$NightBird.enabled = true

func _on_church_audio_switcher_2_body_entered(body: Node3D) -> void:
	if (not body.is_in_group("player")):
		return
	
	$ChurchAmbience.play()
	$ChurchAmbience.volume_db = MIN_VOLUME
	var tween1 = get_tree().create_tween().set_parallel(true)
	tween1.tween_property($ChurchAmbience, "volume_db", MAX_VOLUME, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	var playingAudio: AudioStreamPlayer
	if $DungeonAmbience.playing:
		playingAudio = $DungeonAmbience
	else:
		playingAudio = $NightBugs

	var tween2 = get_tree().create_tween().set_parallel(true)
	tween2.tween_property(playingAudio, "volume_db", MIN_VOLUME, TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	$Cricket.enabled = false
	$Owl.enabled = false
	$NightBird.enabled = false
