extends Area3D

signal trigger()

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

func setPlayerCheckpoint(body : Node):
	if body is Player:
		Globals.spawnPoint = body.position

func _ready():
	# connect("body_entered", handle_body_entered)
	update_properties()
	body_exited.connect(setPlayerCheckpoint)
	body_entered.connect(setPlayerCheckpoint)

func _process(delta):
	pass

func update_properties():
	pass
