extends Node3D


@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

func update_properties():
	# isSpawn = properties["is_spawn"]
	levelName = properties["level_name"] if "level_name" in properties else ""
	entranceName = properties["entrance_name"]
	targetEntrance = properties["target_entrance"]
	

@onready var spawn : Node3D = $Spawn
@onready var aplayer : AnimationPlayer = $AnimationPlayer
@export var isSpawn : bool = false
@onready var playerCheck : Area3D = $Node3D/PlayerCheck
var levelName : String
var entranceName : String 
var targetEntrance : String

func _enter_tree():
	$Node3D/PanelLight.lightStrength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_properties()
	if entranceName == Globals.targetEntrance or entranceName == "entry_1" and OS.is_debug_build():
		$Node3D/PanelLight.lightStrength = 0.0
		var player = preload("res://scenes/player.tscn").instantiate()
		# player.global_position = global_position - Vector3(0, 1.0, 0);
		player.position = spawn.global_position
		player.rotation = spawn.global_rotation
		player.rotate_y(deg_to_rad(-90))
		
		get_tree().get_root().add_child.call_deferred(player)
		has_played = true
		aplayer.play("door_open")
		await get_tree().create_timer(12.0).timeout
		can_leave = true
	else:
		can_leave = true
		# aplayer.play("door_close")

var has_played = false
var has_outroed = false
var can_leave = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not has_played and Globals.currentObjectives.size() == 0:
		has_played = true
		aplayer.play("door_open")
	if Globals.player != null and not has_outroed and playerCheck.overlaps_body(Globals.player) and can_leave and levelName != "NONE" and 12000 < (Time.get_ticks_msec() - Globals.player.lastDeath):
		has_outroed = true
		aplayer.play("door_close")

func nextScene():
	if not playerCheck.overlaps_body(Globals.player):
		has_outroed = false
		aplayer.play("door_open")
		return
	Globals.lastPos = Globals.player.position - spawn.global_position
	Globals.lastRotation = Globals.player.rotation - spawn.global_rotation
	Globals.lastRotation.x = Globals.player.headAngle
	Globals.player.queue_free()
	Globals.targetEntrance = targetEntrance
	Input.flush_buffered_events()
	Manager.changeSceneToNamed(levelName)

func unblindPlayer():
	Globals.player.unblind()
