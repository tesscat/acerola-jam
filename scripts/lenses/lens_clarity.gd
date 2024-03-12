extends Node

@onready var blur : ColorRect = $pp_Blur/ColorRect
@onready var sharpen : ColorRect = $pp_Sharpen/ColorRect
@onready var chroma : ColorRect = $pp_Chroma/ColorRect

var theta = 0.0
var ddt = 0.0
var d2dt2 = 0.0

func _process(delta):
	theta += delta * 5 * sin(ddt)
	ddt += fposmod(d2dt2, 1.0) - 0.5
	d2dt2 = randf_range(-0.2, 0.2)
	chroma.material.set_shader_parameter("theta", theta)
	

func setLensParams(depthTex, screenTex):
	blur.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
	sharpen.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
