extends StaticBody3D

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

func update_properties() -> void:
	if "op_mhz" in properties:
		operatingFreq = properties["op_mhz"]
	if "op_width" in properties:
		operatingWidth = properties["op_width"]
	if "detectable_width" in properties:
		detectableWidth = properties["detectable_width"]


# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	setEnable(false)
	for child in self.get_children():
		if child is MeshInstance3D:
			child.set_surface_override_material(0, load("res://materials/transient_mat.tres").duplicate(true))
			var mat : BaseMaterial3D = child.mesh.surface_get_material(0)
			var tx = mat.albedo_texture
			child.get_surface_override_material(0).set_shader_parameter("tex", tx)
			child.get_surface_override_material(0).set_render_priority(20)

	
	setVisibility(1.0)

	
var gVisibility = -1.0
var currVisibility = 0.0

func setVisibility(visibility):
	# if visibility == gVisibility: return
	gVisibility = clamp(visibility, 0.0, 0.8)
	currVisibility = lerp(currVisibility, gVisibility, get_process_delta_time()*10)
	for child in self.get_children():
		if child is MeshInstance3D:
			#print_debug("THE CHILD", child.get_surface_override_material(0).get_shader_parameter("visibility"))
			child.get_surface_override_material(0).set_shader_parameter("visibility", currVisibility)

var enabled = true

@export var operatingFreq : float = 60.0
@export var operatingWidth : float = 4.0
@export var detectableWidth : float = 8.0

var currFreq
func setEnable(enable):
	if enable == enabled: return
	enabled = enable
	for child in self.get_children():
		if child is CollisionShape3D:
			child.disabled = not enabled

func _process(_delta):
	currFreq = Globals.operatingMhz
	# are we Operating?
	if abs(currFreq - operatingFreq) < operatingWidth:
		# yes we are
		# enable the node
		setVisibility(1.0)
		setEnable(true)
		# disable the shader
		# get_active_material(0).set_shader_parameter("visibility", 1.0)
	# are we visible?
	else:
		var visibility = 0.0
		if abs(currFreq - operatingFreq) < detectableWidth:
			visibility = 1.0 - abs(currFreq - operatingFreq)/detectableWidth
		# get_active_material(0).set_shader_parameter("visibility", visibility)
		setVisibility(visibility)
		setEnable(false)
