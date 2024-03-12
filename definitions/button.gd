class_name ButtonInteractable
extends Area3D

signal trigger()

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

@export var promptText = "LMB: press button"

var ap : AudioStreamPlayer3D

func _ready():
	# connect("body_entered", handle_body_entered)
	update_properties()
	ap = AudioStreamPlayer3D.new()
	ap.stream = preload("res://sfx/button.wav")
	ap.position = position
	add_child(ap)

func _interact():
	emit_signal("trigger")
	ap.play()

func update_properties():
	#if not Engine.is_editor_hint():
	#	return
	
	if "prompt_text" in properties:
		promptText = properties["prompt_text"]
