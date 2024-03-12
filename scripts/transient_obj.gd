extends Node3D



@export var operatingFreq : float = 60.0
@export var operatingWidth : float = 4.0
@export var detectableWidth : float = 8.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var currFreq

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	currFreq = Globals.operatingMhz
	# are we Operating?
	if abs(currFreq - operatingFreq) < operatingWidth:
		print_debug("operating")
		# yes we are
		# enable the node
		for target in self.get_children():
			target.setVisibility(1.0)
			target.setEnable(true)
		# disable the shader
		# get_active_material(0).set_shader_parameter("visibility", 1.0)
	# are we visible?
	else:
		var visibility = 0.0
		if abs(currFreq - operatingFreq) < detectableWidth:
			visibility = 1.0 - abs(currFreq - operatingFreq)/detectableWidth
		# get_active_material(0).set_shader_parameter("visibility", visibility)
		for target in self.get_children():
			target.setVisibility(visibility)
			target.setEnable(false)
