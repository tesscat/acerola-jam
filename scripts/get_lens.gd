extends Area3D

@export var promptText = "LMB: Take lens"
@export var MI : MeshInstance3D
@export var lensNumber : int = 1
@export var loreText = "You got a Lens! Press [2] to equip it."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var interacted = false

func _interact():
	if interacted: return
	promptText = ""
	MI.visible = false
	interacted = true
	if Globals.lensesObtained < lensNumber:
		Globals.lensesObtained += 1
		Globals.player.displayLore(loreText)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
