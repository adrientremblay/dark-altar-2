extends Node3D

var MAX_Y_SCALE = 0.12
var MIN_Y_SCALE = 0.02
var CANDLE_DET_SPEED = 0.01

var candle_health = 100
var candle_y_scale = MAX_Y_SCALE

func _process(delta: float) -> void:
	candle_burn(delta)

func candle_burn(delta: float):
	candle_y_scale = max(MIN_Y_SCALE, candle_y_scale - (CANDLE_DET_SPEED * delta))
	self.scale.y = candle_y_scale
	print(candle_y_scale)
