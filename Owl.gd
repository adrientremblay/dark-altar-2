extends AudioStreamPlayer

var random = RandomNumberGenerator.new()

func _on_timer_timeout() -> void:
	play()
	$Timer.start(random.randi_range(15, 30))