extends AudioStreamPlayer

var random = RandomNumberGenerator.new()

var enabled = true

func _on_timer_timeout() -> void:
	if enabled:
		play()
	$Timer.start(random.randi_range(15, 30))
