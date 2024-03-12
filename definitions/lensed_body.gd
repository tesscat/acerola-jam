extends StaticBody3D

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

func update_properties() -> void:
	lensBitmask = properties["lens_flags"]

var transBodies = []
var trueBodies = []
var testBodies = []
var a3d : Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	enabled = false
	a3d = Area3D.new()
	add_child(a3d)
	for child in self.get_children():
		if child is MeshInstance3D:
			transBodies.append(child)
			var dup = child.duplicate(1 & 2 & 4)
			dup.visible = false
			add_child(dup)
			trueBodies.append(dup)
			for i in child.get_surface_override_material_count():
				child.set_surface_override_material(i, load("res://materials/lensed_mat.tres").duplicate(true))
				child.get_surface_override_material(i).set_shader_parameter("isEnabled", false)
				var mat : BaseMaterial3D = child.mesh.surface_get_material(0)
				var tx = mat.albedo_texture
				child.get_surface_override_material(i).set_shader_parameter("tex", tx)
				child.get_surface_override_material(i).set_render_priority(20)
		if child is CollisionShape3D:
			var dup = child.duplicate(1 & 2 & 4)
			testBodies.append(dup)
			a3d.add_child(dup)
	checkIfEnableable()



	
var enabled : bool = false
var actuallyEnabled : bool = true


func checkIfEnableable():
	if actuallyEnabled == enabled: return
	if not enabled:
		actuallyEnabled = false
	# check if we may proceed (no child has interesections)
	elif a3d.overlaps_body(Globals.player):
		return
	actuallyEnabled = enabled
	setPhysicsEnable(actuallyEnabled)
	for child in trueBodies:
		child.visible = actuallyEnabled
	for child in transBodies:
		child.visible = not actuallyEnabled

@export var lensBitmask : int;

var currFreq
func setPhysicsEnable(enable):
	enabled = enable
	for child in self.get_children():
		if child is CollisionShape3D:
			child.disabled = not enabled

func _process(_delta):
	var currLens = Globals.lensIdx
	if lensBitmask & (1 << currLens) != 0 :
		enabled = true
	else:
		enabled = false
	checkIfEnableable()
