extends CanvasLayer

var akcArmed = false

@export var nextLevel : String = ""

func armAKC():
	akcArmed = true
	$AudioStreamPlayer.playing = false

func _ready():
	var label = $AnyKeyContinue
	var txt = label.text
	label.text = ""
	label.visible = true
	
	if false and OS.is_debug_build():
		if nextLevel == "":
			Globals.targetEntrance = "entry_1"
			Manager.changeSceneLinearly()
		else:
			# Globals.targetEntrance = "main_entrance"
			Manager.changeSceneToNamed(nextLevel)
	else:
		Utils.anim_in(txt, label, armAKC)

func _input(event):
	if akcArmed and event is InputEventKey and Globals.lastSceneTicksOnChange + 200 < Time.get_ticks_msec():
		if nextLevel == "":
			Globals.targetEntrance = "entry_1"
			Manager.changeSceneLinearly()
		else:
			Manager.changeSceneToNamed(nextLevel)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer.playing and not akcArmed and $AudioStreamPlayer.stream != null:
		$AudioStreamPlayer.play()
