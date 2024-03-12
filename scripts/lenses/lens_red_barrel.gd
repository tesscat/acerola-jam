extends Node

@onready var fisheye : ColorRect = $pp_Fisheye/ColorRect

func setLensParams(depthTex, screenTex):
	fisheye.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
