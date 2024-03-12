extends Node2D

func skip():
	Globals.targetEntrance = "main_entrance"
	Manager.changeSceneToNamed("atrium")

# Called when the node enters the scene tree for the first time.
func _ready():
	if "lore_second_contact" in Globals.loreSeen and false:
		skip.call_deferred()
	else:
		$CanvasLayer.nextLevel = "atrium"
		Globals.targetEntrance = "main_entrance"
		Globals.loreSeen.append("lore_second_contact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
