extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer.nextLevel = "title"
	Globals.targetEntrance = "entry_1"
		# Globals.loreSeen.append("lore_first_contact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
