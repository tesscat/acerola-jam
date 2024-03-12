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

func _ready():
	$SpotLight3D.light_energy = lightStrength

func _process(_delta):
	$SpotLight3D.light_energy = lightStrength
