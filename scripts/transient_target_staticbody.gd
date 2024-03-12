extends StaticBody3D
class_name TransientTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	setEnable(false)
	setVisibility(1.0)
	
var gVisibility = -1.0
var currVisibility = 0.0

func setVisibility(visibility):
	# if visibility == gVisibility: return
	gVisibility = clamp(visibility, 0.0, 0.8)
	currVisibility = lerp(currVisibility, gVisibility, get_process_delta_time()*10)
	for child in self.get_children():
		if child is MeshInstance3D:
			pass
			#print_debug("THE CHILD", child.get_surface_override_material(0).get_shader_parameter("visibility"))
			child.get_surface_override_material(0).set_shader_parameter("visibility", currVisibility)

var enabled = true

func setEnable(enable):
	if enable == enabled: return
	enabled = enable
	for child in self.get_children():
		if child is CollisionShape3D:
			child.disabled = not enabled

