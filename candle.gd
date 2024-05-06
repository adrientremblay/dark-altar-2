extends Node3D

@onready var flame : GPUParticles3D = $Flame
@onready var flame_light : OmniLight3D = $WorldLight
@onready var hand_light : OmniLight3D = $PlayerLight

var MAX_Y_SCALE = 0.12
var MIN_Y_SCALE = 0.02
var CANDLE_DET_SPEED = 0.0005 * 2 * 2

var MAX_LIGHT_ENERGY = 10
var MIN_LIGHT_ENERGY = 2

var MAX_LIGHT_ENERGY_HAND = 13.118
var MIN_LIGHT_ENERGY_HAND = 3

var MAX_LIGHT_RANGE = 12
var MIN_LIGHT_RAMGE = 2

var candle_y_scale = MAX_Y_SCALE

func _process(delta: float) -> void:
	candle_burn(delta)

func candle_burn(delta: float):
	# candle height
	candle_y_scale = max(MIN_Y_SCALE, candle_y_scale - (CANDLE_DET_SPEED * delta))
	self.scale.y = candle_y_scale
	
	# candle going out
	if candle_y_scale == MIN_Y_SCALE:
		$Flame.visible = false
		$WorldLight.visible = false
		$PlayerLight.visible = false
		return
	
	# light energy
	var light_ratio = candle_y_scale / MAX_Y_SCALE
	var light_energy = light_ratio * MAX_LIGHT_ENERGY
	flame_light.light_energy = max(MIN_LIGHT_ENERGY, light_energy)
	
	# hand energy
	var hand_light_energy = light_ratio * MAX_LIGHT_ENERGY_HAND
	hand_light.light_energy = max(MIN_LIGHT_ENERGY_HAND, hand_light_energy)
	
	# light range
	var light_range = max(MIN_LIGHT_RAMGE, light_ratio * MAX_LIGHT_RANGE)
	flame_light.omni_range = light_range

func replenish():
	candle_y_scale = MAX_Y_SCALE
	$Flame.visible = true
	$WorldLight.visible = true
	$PlayerLight.visible = true
