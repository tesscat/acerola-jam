extends Node

@onready var dilate : ColorRect = $pp_Dilate/ColorRect
@onready var lens : ColorRect = $pp_Lens/ColorRect

func setLensParams(depthTex, screenTex):
	dilate.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
	lens.material.set_shader_parameter("SCREEN_TEXTURE", screenTex)
	lens.material.set_shader_parameter("DEPTH_TEXTURE", depthTex)
