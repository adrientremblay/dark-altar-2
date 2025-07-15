extends Node3D

func _on_start_game_button_pressed() -> void:
	$UI.visible = false
	$Camera3D.queue_free()
	$BlackPanel.visible = true
	$MusicPlayer.stop()
	$IntroDialogue.play()
	$DialogueLabel.visible = true

func _on_controls_button_pressed() -> void:
	$UI/Menus/Lore.visible = false
	$UI/Menus/Controls.visible = true
	$ButtonPressSound.play()

func _on_lore_button_pressed() -> void:
	$UI/Menus/Lore.visible = true
	$UI/Menus/Controls.visible = false
	$ButtonPressSound.play()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func switch_level() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_intro_dialogue_finished() -> void:
	switch_level()
