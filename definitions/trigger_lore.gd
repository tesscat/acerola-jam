extends Area3D

signal trigger()

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

@export var lore : String
@export var promptText : String = "LMB: Read tape"
@export var sfxPath : String = "res://sfx/vhs_insert.mp3"
var read = false
var ap
func update_properties():
	lore = properties["lore"].replace("\\n", "\n").replace("\\", "")
	promptText = properties["prompt_text"]
	sfxPath = properties["sfx_path"]

func _interact():
	if read: return
	read = true
	ap.play()
	promptText = ""
	await get_tree().create_timer(1.0).timeout
	Globals.player.displayLore(lore)
	emit_signal("trigger")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	ap = AudioStreamPlayer.new()
	print_debug(sfxPath)
	if sfxPath != "":
		ap.stream = load(sfxPath)
	ap.volume_db = 3.0
	# ap.position = position
	add_child(ap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
