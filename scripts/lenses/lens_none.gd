extends Node

@onready var lens : ColorRect = $pp_None/ColorRect

func setLensParams(depthTex, screenTex):
	lens.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
