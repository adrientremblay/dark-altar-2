extends Node3D

@onready var flame : GPUParticles3D = $Flame
@onready var flame_light : OmniLight3D = $WorldLight

var MAX_Y_SCALE = 0.12
var MIN_Y_SCALE = 0.02
var CANDLE_DET_SPEED = 0.01

var MAX_LIGHT_ENERGY = 10
var MIN_LIGHT_ENERGY = 2

var MAX_LIGHT_RANGE = 8
var MIN_LIGHT_RAMGE = 2

var candle_y_scale = MAX_Y_SCALE

func _process(delta: float) -> void:
	candle_burn(delta)

func candle_burn(delta: float):
	# candle height
	candle_y_scale = max(MIN_Y_SCALE, candle_y_scale - (CANDLE_DET_SPEED * delta))
	self.scale.y = candle_y_scale
	
	# light energy
	var light_ratio = candle_y_scale / MAX_Y_SCALE
	var light_energy = light_ratio * MAX_LIGHT_ENERGY
	flame_light.light_energy = max(MIN_LIGHT_ENERGY, light_energy)

	# light range
	var light_range = max(MIN_LIGHT_RAMGE, light_ratio * MAX_LIGHT_RANGE)
	flame_light.omni_range = light_range
