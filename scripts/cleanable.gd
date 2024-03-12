extends Interactable

@export var hp = 0.0
@export var toolRequired = ""

func _ready():
	promptText = "LMB: clean"
	super._ready()

func _interact():
	print_debug("clened")
	super._interact()
