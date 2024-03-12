extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var has_played = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not has_played and Globals.currentObjectives.size() == 0:
		has_played = true
		play("door_open")
