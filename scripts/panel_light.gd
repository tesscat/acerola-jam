extends Node3D


# Called when the node enters the scene tree for the first time.
#func _ready():
	# print_debug("PANEL LIGHT IS HERE")

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

func update_properties():
	lightStrength = properties["light_strength"]

@export var lightStrength = 0.2

@onready var spot : SpotLight3D = $SpotLight3D
@onready var mesh : MeshInstance3D = $MeshInstance3D
func _ready():
	spot.light_energy = lightStrength
	mesh.get_surface_override_material(0).emission_energy_multiplier = lightStrength

func _process(_delta):
	spot.light_energy = lightStrength
	mesh.get_surface_override_material(0).emission_energy_multiplier = lightStrength
