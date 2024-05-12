extends AudioStreamPlayer

var random = RandomNumberGenerator.new()

func _on_timer_timeout() -> void:
	print("playing")
	play()
	$Timer.start(random.randi_range(15, 30))
