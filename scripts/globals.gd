extends Node
class_name c_Globals

# var operatingMhz : float = 40.0
var holding : Node = null
var spawnPoint : Vector3 = Vector3.ZERO
var lensIdx : int = -1
var inventory : Array = []
var currentObjectives : Array = []
var currentObjectivePositions : Array = []
var player : Player
var lensesObtained : int = 0
var lastRotation = null
var lastPos = null
var lastSceneTicksOnChange : int
var playerDialogue : Label

var bgm = true

var loreSeen : Array = []
var targetEntrance : String = ""

func _ready():
	if OS.is_debug_build():
		lensesObtained = 3

func resetLocal():
	player = null
	currentObjectives = []
	lensIdx = 0
	lastSceneTicksOnChange = Time.get_ticks_msec()
	spawnPoint = Vector3.ZERO
