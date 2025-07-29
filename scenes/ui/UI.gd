extends CanvasLayer

@onready var message_label : Label = $MessageLabel
@onready var message_timer : Timer = $MessageTimer

func _ready() -> void:
	$MessageLabel.visible = false

func display_message(message):
	message_label.text = message
	message_label.visible = true
	message_timer.start()

func display_dialogue(message):
	message_label.text = message
	message_label.visible = true
	message_timer.stop()

func hide_message_label():
	message_label.visible = false
	
func _on_player_register_skull(skulls_found: int) -> void:
	display_message("Skull " + str(skulls_found) + "/5 collected")

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
	display_message("The key to the church was hidden beneath this final skull")

func _on_message_timer_timeout() -> void:
	message_label.visible = false
	message_timer.stop()
