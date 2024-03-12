extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var panel : StaticBody3D = $Area3D

@onready var targetY = panel.transform.origin.y

func open():
	targetY = -2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	panel.transform.origin.y = lerp(panel.transform.origin.y, targetY, delta*4)


func _on_button_interacted():
	pass # Replace with function body.
