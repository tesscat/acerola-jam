extends Node
class_name Interactable

@export var promptText = "LMB: click"
@export var triggerSignal = "trigger"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _interact():
	print_debug("INTERACTION")
	emit_signal(triggerSignal)
