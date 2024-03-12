extends Light3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var on = true

func _on_interacted():
	on = not on
	light_energy = 1.0 if on else 0.0 

