extends Node2D

func is_alphanum(i : int):
	return (65 <= i and i <= 90) or (97 <= i and i <= 122)


func initButtons():
	$AudioStreamPlayer.playing = false
	$CanvasLayer/Buttons.visible = true


# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $CanvasLayer/Label
	var origTxt = label.text
	label.text = ""
	Utils.anim_in(origTxt, label, initButtons)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#if OS.is_debug_build():
	#	Manager.changeSceneLinearly()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Manager.changeSceneLinearly()

func on_quit_pressed():
	get_tree().quit()
func on_credits_pressed():
	$CanvasLayer/Credits.visible = not $CanvasLayer/Credits.visible
