extends Node


const linearProgression = {"title":preload("res://scenes/title.tscn"), 
	"tutorial": preload("res://scenes/lore/lore_tutorial.tscn"),
	"disclaimer": preload("res://scenes/lore/lore_disclaimer.tscn"),
	"lore_intro": preload("res://scenes/lore/lore_intro.tscn"),
	"l0":preload("res://scenes/levels/Level_0.tscn"),
	"l1":preload("res://scenes/levels/Level_1.tscn"),
	"atrium":preload("res://scenes/levels/Atrium.tscn"),
	# the barrel arc
	"barrel_1":preload("res://scenes/levels/Barrel_1.tscn"),
	"lore_first_contact":preload("res://scenes/lore/lore_first_contact.tscn"),
	# the DOF arc (now clarity)
	"dof_1":preload("res://scenes/levels/Dof_1.tscn"),
	"dof_2":preload("res://scenes/levels/Dof_2.tscn"),
	"dof_3":preload("res://scenes/levels/Dof_3.tscn"),
	# TODO: lore scene
	"lore_second_contact":preload("res://scenes/lore/lore_second_contact.tscn"),
	# the true ending arc
	"ending_1":preload("res://scenes/levels/Ending_1.tscn"),
	"ending_lore":preload("res://scenes/levels/Ending_Lore.tscn"),
	"ending_2":preload("res://scenes/levels/Ending_2.tscn"),
	"ending_cutscene":preload("res://scenes/lore/lore_true_ending.tscn"),
	# the evac ending
	"evac_1": preload("res://scenes/levels/Evac_1.tscn"),
	"evac_2":preload("res://scenes/levels/Evac_2.tscn"),
	"ending_evac":preload("res://scenes/lore/lore_evac_ending.tscn"),
	"finish":preload("res://scenes/levels/LevelNull.tscn")}
var currentSceneIdx = 0

func changeSceneLinearly():
	print_debug("CHANGING SCENE LINEARLY")
	print_debug("target scene is ", linearProgression.keys()[currentSceneIdx + 1])
	print_debug("target entrance is ", Globals.targetEntrance)
	currentSceneIdx += 1
	currentSceneIdx = currentSceneIdx % linearProgression.size()
	Globals.resetLocal()
	get_tree().change_scene_to_packed(linearProgression.values()[currentSceneIdx])

func changeSceneToNamed(name: String):
	print_debug("CHANGING TO NAME ", name)
	Globals.resetLocal()
	currentSceneIdx = linearProgression.keys().find(name)
	get_tree().change_scene_to_packed(linearProgression[name])
# Called when the node enters the scene tree for the first time.
func _ready():
	# True Initialisation
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
