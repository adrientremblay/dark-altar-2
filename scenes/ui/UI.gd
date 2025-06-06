extends CanvasLayer

var intro_label = 1

func _on_intro_timer_timeout() -> void:
	match intro_label:
		1:
			print("Boom1")
			$BOOM.play()
			$Label.visible = true
		2:
			$IntroTimer.stop()
			$Label.visible = false
	intro_label +=1

func _on_player_register_skull(skulls_found: int) -> void:
	intro_label = 2
	$IntroTimer.start()
	$Label.text = "skull " + str(skulls_found) + "/5 collected"
	$Label.visible = true

func _on_player_can_interact_with_something() -> void:
	$InteractHand.visible = true

func _on_player_cannot_interact_with_something() -> void:
	$InteractHand.visible = false
	
func display_page(page : Page):
	$PageFlip.play()
	if $PageView.visible:
		$PageView.visible = false
		$ThemeMusic.stop();
		return
	
	$ThemeMusic.play();
	$PageView.visible = true
	$PageView/PageTitle.text = page.page_title
	$PageView/PageText.text = page.page_text
	$InteractHand.visible = false

func toggle_pause_menu(toggle: bool):
	$PauseMenu.visible = toggle

func display_banish_message():
	$Label.text = "head to the summoning chamber and place the skulls"
	$Label.visible = true
	print("Boom2")
	$BOOM.play()
	intro_label = 2
	$IntroTimer.start()
	pass
