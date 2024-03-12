extends CanvasLayer

func bringInPromptHelp():
	var label = $PromptHelp
	var txt = label.text
	label.text = ""
	label.visible = true
	Utils.anim_in(txt, label, bringInSprintHelp)

func bringInSprintHelp():
	var label = $SprintHelp
	var txt = label.text
	label.text = ""
	label.visible = true
	Utils.anim_in(txt, label, bringInAKC)


func _input(event):
	if event is InputEventKey and akc:
		Manager.changeSceneLinearly()

var akc = false

func armAKC():
	$AudioStreamPlayer.playing = false
	akc = true

func bringInAKC():
	var label = $AnyKeyContinue
	var txt = label.text
	label.text = ""
	label.visible = true
	Utils.anim_in(txt, label, armAKC)
# Called when the node enters the scene tree for the first time.
func _ready():
	bringInPromptHelp()
	return
	var label = $ObjectiveHelp
	var txt = label.text
	label.text = ""
	label.visible = true
	Utils.anim_in(txt, label, bringInPromptHelp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
