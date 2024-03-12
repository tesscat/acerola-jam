extends Area3D

signal trigger()

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

@export var promptText = "LMB: complete objective"
@export var requirements = []
var pt
var completed = false
@export var sfx : AudioStream = null
@export var volume : float = 0
var ap = null

func _ready():
	# update_properties()
	# connect("body_entered", handle_body_entered)
	# update_properties()
	if sfx != null:
		ap = AudioStreamPlayer.new()
		ap.volume_db = volume
		ap.stream = sfx
		add_child(ap)

func _interact():
	if completed: return
	emit_signal("trigger")
	if ap != null:
		ap.play()
	var has_all = true
	for req in requirements:
		if not req in Globals.inventory:
			has_all = false
			break
	if has_all:
		var idx = Globals.currentObjectives.find(pt)
		Globals.currentObjectives.remove_at(idx)
		Globals.currentObjectivePositions.remove_at(idx)
		completed = true
		promptText = ""

func update_properties():
	#if not Engine.is_editor_hint():
	#	return
	
	if "requirements" in properties:
		var reqs : String = properties["requirements"]
		requirements = reqs.split(" ")
	
	if "prompt_text" in properties:
		pt = properties["prompt_text"]
		if requirements != []:
			pt += " [requires " + ", ".join(requirements) + "]"
	
	if "sfx" in properties:
		sfx = load(properties["sfx"])
	
	if "volume" in properties:
		volume = (properties["volume"])
	
	Globals.currentObjectives.append(pt)
	Globals.currentObjectivePositions.append(global_position)
	promptText = "LMB: " + pt
