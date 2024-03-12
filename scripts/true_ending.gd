extends Area3D

var node

func body_has_entered(body):
	if not body is Player: return
	# it is game over.
	Globals.player.paralyze = true
	Globals.bgm = false
	node = Globals.playerDialogue
	await get_tree().create_timer(0.4).timeout
	Globals.player.setCurrentLens(2)
	await get_tree().create_timer(0.4).timeout
	# begin the monologing
	node.text = ""
	Utils.anim_in("It's me.\nYou're here. Finally.", node, catchFinally, false)
func catchFinally():
	await get_tree().create_timer(2.0).timeout
	node.text = ""
	Utils.anim_in("You know, you're the last one.\nThe last thing that can be considered semi-sentient.\nAfter you, the world will finally be uniform.", node, catchUniform, false)
func catchUniform():
	await get_tree().create_timer(2.0).timeout
	node.text = ""
	Utils.anim_in("How does it feel?\nTo be the last aberration remaining?", node, catchRemaining, false)
func catchRemaining():
	await get_tree().create_timer(2.0).timeout
	node.text = ""
	Utils.anim_in("I forget, you cannot speak.\nWell, this is it I guess.", node, catchGuess, false)
func catchGuess():
	await get_tree().create_timer(2.0).timeout
	node.text = ""
	Utils.anim_in("Enjoying the final moments of the sentient universe?", node, catchUniverse, false)
func catchUniverse():
	await get_tree().create_timer(2.0).timeout
	node.text = ""
	Utils.anim_in("Yeah, thought not.", node, catchNot, false)
func catchNot():
	await get_tree().create_timer(2.0).timeout
	
	Globals.player.setCurrentLens(0)
	# do kill
	Globals.player.queue_free()
	Manager.changeSceneToNamed("ending_cutscene")
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(body_has_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
