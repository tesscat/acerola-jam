extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.targetEntrance = "entry_1"
	$CanvasLayer.nextLevel = "l0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
