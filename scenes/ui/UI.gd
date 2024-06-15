extends Control

var intro_label = 1

func _on_intro_timer_timeout() -> void:
	match intro_label:
		1:
			$IntroTimer.stop()
			$Label.visible = false
	intro_label +=1

func _on_player_register_skull() -> void:
	intro_label = 1
	$IntroTimer.start()
	$Label.text = "skull collected"
	$Label.visible = true

func _on_player_can_interact_with_something() -> void:
	$InteractHand.visible = true

func _on_player_cannot_interact_with_something() -> void:
	$InteractHand.visible = false
	
func display_page(page : Page):
	$PageFlip.play()
	if $PageView.visible:
		$PageView.visible = false
		return
	
	$PageView.visible = true
	$PageView/PageTitle.text = page.page_title
	$PageView/PageText.text = page.page_text
	$InteractHand.visible = false
