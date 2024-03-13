extends CharacterBody3D
class_name Player

@export_group("Character Settings")
@export var jumpVel : float = 4.0
@export var walkVel : float = 1.8
@export var sprintVel : float = 3.0
@export var headBobIntensity : float = 0.8
@export var headBobSpeed : float = 20.0
@export var groundFriction : float = 14.0
@export var airFriction : float = 3.0
@export var airFloat : float = 1.0
@export var airDecel : float = 1.0
@export var groundDecel : float = 6.0
@export var terminalSpeed : float = 20
@export var sprintTime : float = 15.0
@export var sprintRechargeSpeed : float = 3.0
@export var paralyze : bool = false


@export_group("Controls")
@export var left : String = "gm_left"
@export var right : String = "gm_right"
@export var back : String = "gm_backward"
@export var fwd : String = "gm_forward"
@export var jump : String = "gm_jump"
@export var interact : String = "gm_interact"
@export var freqUp : String = "gm_scroll_up"
@export var freqDown : String = "gm_scroll_down"
@export var sprint : String = "gm_sprint"
@export var crouch : String = "gm_crouch"
@export var suicide : String = "gm_reset"
@export var scan : String = "gm_scan"
@export var freqSens : float = 1.0
@export var mouseSens : float = 0.3
@export var coyoteThresh : float = 0.2



@onready var depthVP : SubViewport = $Head/DepthVP
@onready var colourVP : SubViewport = $Head/ColourVP
@onready var camBase : Node = $Head
# actually handles the depth
@onready var camNode : Camera3D = camBase.get_node("DepthVP/Camera3D")
@onready var camNode_Colour : Camera3D = camBase.get_node("ColourVP/Camera3D")
@onready var headNode = camBase
@onready var rayNode : RayCast3D = camBase.get_node("RayCast3D")
@onready var headTorch : Light3D = camBase.get_node("SpotLight3D")
@onready var lensScenes = [preload("res://scenes/lenses/lens_none.tscn"),
	# preload("res://scenes/lenses/red_barrel.tscn"),
	preload("res://scenes/lenses/lens_warm_dof.tscn"),
	preload("res://scenes/lenses/lens_clarity.tscn")]
var currentLensIdx = -1
@onready var currentLens = null #  = (lensScenes[currentLensIdx].instantiate())
@onready var windPlayer : AudioStreamPlayer = $Wind

@export var headAngle : float = 0

var currentSpd = walkVel
var lastVel = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var headBobVec = Vector2.ZERO
var headBobOffs = 0.0
var headBobCurrInts = 0.0
var coyoteTime = 0.0
var direction = Vector3.ZERO
var sprintTimeCurr = sprintTime

# bound between 40 and 100
# var operatingMhz = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_constant_speed = true
	floor_max_angle = deg_to_rad(60)
	Globals.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.spawnPoint = position
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	setCurrentLens(0)
	Globals.playerDialogue = $pp0_HUD/Dialogue
	await get_tree().create_timer(0.2).timeout
	$Blind.visible = false

func unblind():
	$Blind.visible = false
	$Blind/ColorRect.visible = false

func setCurrentLens(newCurrent):
	if newCurrent == currentLensIdx: return
	Globals.lensIdx = newCurrent
	if is_instance_valid(currentLens):
		remove_child(currentLens)
		currentLens.queue_free()
	currentLensIdx = newCurrent
	currentLens = lensScenes[currentLensIdx].instantiate()
	add_child(currentLens)
	headNode.global_rotation.x = headAngle

var bigMotion = 40.0

const numberKeys = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0]

func _input(event):
	if event is InputEventMouseMotion:
		if event.relative.y > bigMotion: return
		rotate_y(deg_to_rad(-event.relative.x * mouseSens))
		headNode.global_rotation.x +=  (deg_to_rad(-event.relative.y * mouseSens))
		headNode.global_rotation.x = clampf(headNode.global_rotation.x, deg_to_rad(-70), deg_to_rad(70))
		headAngle = headNode.global_rotation.x
	# handle lens switching
	if event is InputEventKey:
		if paralyze: return
		if event.echo or not event.pressed: return
		if not event.physical_keycode in numberKeys: return
		# can be replaced with numeric code but who cba
		var kIdx = numberKeys.find(event.physical_keycode)
		if kIdx >= lensScenes.size(): return
		# TODO: check if lens is available
		if kIdx <= Globals.lensesObtained:
			setCurrentLens(kIdx)
var lastDeath = 0.0
var dieCountdown = 0.0
func die():
	if dieCountdown > 0.0: return
	lastDeath = Time.get_ticks_msec()
	position = Globals.spawnPoint
	$Thunk.play()
	lastVel.y = 0.0
	glitchStrength = 0.3
	dieCountdown = 1.5

func cleanupLore(wasCancelled):
	if not wasCancelled:
		await get_tree().create_timer(2.0).timeout
	$pp0_HUD/Dialogue.text = ""
	loreStack.remove_at(0)
	if wasCancelled:
		Utils.anim_in(loreStack[0], $pp0_HUD/Dialogue, cleanupLore, false, handleShouldCancel, true)

var loreStack = []
var shouldCancelBool = false
func handleShouldCancel():
	if shouldCancelBool:
		shouldCancelBool = false
		return true
	return false

func displayLore(lore: String):
	loreStack.append(lore)
	if loreStack.size() != 1:
		shouldCancelBool = true
	else:
		Utils.anim_in(lore, $pp0_HUD/Dialogue, cleanupLore, false, handleShouldCancel, true)

var glitchStrength = 0.3
var glitchDecayBase = 0.985
func strengthToTime(s):
	return log(s)/log(glitchDecayBase)
func timeToStrength(t):
	return pow(glitchDecayBase, t)
func stepGlitch(delta):
	# decay the glitch coeff
	# if it's Big, drag it on a bit
	if glitchStrength > 0.8:
		glitchDecayBase = 0.9
	else:
		glitchDecayBase = 0.50
	glitchStrength = timeToStrength(strengthToTime(glitchStrength) + delta)
	glitchStrength = clamp(glitchStrength, 0.2, 1.0)
	# override if we're dead
	if dieCountdown > 0.0:
		glitchStrength = 3.0
	# apply the relevant properties
	# if glitchStrength != 0 : print_debug("GS: ", glitchStrength)
	$pp2_GlitchMap/ColorRect.material.set_shader_parameter("invIntensity", 1.0 - clamp(60*glitchStrength - 57.0, 0, 10))
	$pp2_GlitchMap/ColorRect.material.set_shader_parameter("glitchOverlay", clamp(glitchStrength/3.0, 0, 3))
	# $pp2_GlitchMap/ColorRect.material.set_shader_parameter("warpStrength", pow(glitchIntens - 0.6, 3) if glitchIntens > 0.6 else 0.0)
	$pp1_VBars/ColorRect.material.set_shader_parameter("colourSplitIntensity", clamp(30*glitchStrength - 26.0, 0, 10))
	$pp1_VBars/ColorRect.material.set_shader_parameter("noiseIntensity_u", clamp(25*glitchStrength - 20.0, 0.4, 10))
	$pp1_VBars/ColorRect.material.set_shader_parameter("barsIntensity", clamp(3*glitchStrength - 0.2, 0, 0.3))

var physFps = 0.0
func _physics_process(delta):
	stepGlitch(delta)
	if dieCountdown > 0.0: return
	if paralyze: return
	physFps = 1/delta
	var inpDir = Input.get_vector(left, right, fwd, back)
	var speed = walkVel
	if Input.is_action_just_pressed(suicide):
		die()
		return
	# useful for when I add sprinting/crouching
	if Input.is_action_pressed(crouch):
		pass
	if Input.is_action_pressed(sprint) and sprintTimeCurr > 0.0 and not Input.is_action_pressed(crouch):
		sprintTimeCurr -= delta
		speed = sprintVel
	elif not Input.is_action_pressed(sprint):
		sprintTimeCurr += delta*sprintRechargeSpeed
		sprintTimeCurr = clamp(sprintTimeCurr, 0.0, sprintTime)
	
	var sprintFrac = round(4*(sprintTimeCurr/sprintTime))
	$pp0_HUD/Sprint.text = "#".repeat(sprintFrac)
		
	currentSpd = lerpf(currentSpd, speed, delta*45)
	
	# again for if i add the other states
	headBobCurrInts = headBobIntensity
	headBobOffs += headBobSpeed * delta
	# head bob!!!
	if is_on_floor() and inpDir != Vector2.ZERO:
		headBobVec.y = (sin(headBobOffs)* headBobCurrInts/2) + 0.14
		headBobVec.x = sin(headBobOffs/2)*headBobCurrInts
	else:
		headBobVec = Vector2.ZERO
	camNode.position.x = lerp(camNode.position.x, headBobVec.x * headBobCurrInts, delta*10)
	camNode.position.y = lerp(camNode.position.y, headBobVec.y*(headBobCurrInts/2), delta*10)
	headTorch.position.y = 0.28 - camNode.position.y
	headTorch.position.x = -camNode.position.x
		
	
	# gravity
	if !is_on_floor():
		velocity.y -= gravity*delta
		if velocity.y < -terminalSpeed: velocity.y = -terminalSpeed
		coyoteTime += delta
	else:
		coyoteTime = 0
	
	# jumpin
	if Input.is_action_just_pressed(jump) and coyoteTime < coyoteThresh:
		velocity.y = jumpVel
		coyoteTime += coyoteThresh
	
	# movin
	if is_on_floor():
		if lastVel.y < 0.0:
			#spike gS
			if lastVel.y < -17.0:
				print_debug("Died to falling")
				die()
			elif lastVel.y < -1.0:
				glitchStrength = max(1.4*pow(abs(lastVel.y)/(terminalSpeed), 0.33), glitchStrength) # timeToStrength(currTime*(0.8/abs(lastVel.y)))
				$pp2_GlitchMap/ColorRect.material.set_shader_parameter("rSeed", Time.get_ticks_msec())
			
		direction = lerp(direction, (transform.basis * Vector3(inpDir.x, 0, inpDir.y)).normalized(), delta*groundFriction)
	else:
		if direction != Vector3.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(inpDir.x, 0, inpDir.y)).normalized(), delta*airFriction)
		else:
			direction = lerp(direction, (transform.basis * Vector3(inpDir.x, 0, inpDir.y)).normalized(), delta*airFloat)
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * currentSpd
		velocity.z = direction.z * currentSpd
	else:
		# decel
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, delta*groundDecel) # move_toward(velocity.x, 0.0, currentSpd)
			velocity.z = lerp(velocity.y, 0.0, delta*groundDecel) # move_toward(velocity.z, 0.0, currentSpd)
		else:
			velocity.x = lerp(velocity.x, 0.0, delta*airDecel) # move_toward(velocity.x, 0.0, currentSpd)
			velocity.z = lerp(velocity.y, 0.0, delta*airDecel) # move_toward(velocity.z, 0.0, currentSpd)
	lastVel = velocity
	move_and_slide()
	
	# check if we fell off
	if position.y < -100.0:
		die()

@onready var HUD : CanvasLayer = $pp0_HUD

func scanForObjectives():
	for i in Globals.currentObjectives.size():
		var pos = camNode_Colour.unproject_position(Globals.currentObjectivePositions[i])
		print_debug("POS: ", pos)
		if camNode_Colour.is_position_behind(Globals.currentObjectivePositions[i]):
			print_debug("BEHIND")
		print_debug("TF ", colourVP.get_final_transform())
		print_debug("VR ", colourVP.get_visible_rect())
		var newHighlight = Label.new()
		newHighlight.text = "> <"
		newHighlight.theme = preload("res://themes/VHS.tres")
		# newHighlight.set_anchors_preset(Control.PRESET_CENTER)
		HUD.add_child(newHighlight)
		newHighlight.set_position(pos + Vector2(-240.0, 90.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dieCountdown > 0.0:
		dieCountdown -= delta
		if dieCountdown <= 0.0:
			position = Globals.spawnPoint
			lastVel = Vector3.ZERO
			velocity = Vector3.ZERO
	
	#if Input.is_action_just_pressed(scan):
	#	scanForObjectives()
	
	if not windPlayer.playing:
		windPlayer.play()
	# woosh math
	var woosh = -lastVel.y - 5.0
	if woosh <= 0:
		woosh = 0.0001
	windPlayer.volume_db = log(woosh) - 17.0
	
	var objText = ""
	if OS.is_debug_build():
		var fps = Engine.get_frames_per_second()
		objText += "FPS: " + str(roundf(fps)) + "\n"
	if Globals.currentObjectives.size() != 0:
		objText += " - " + "\n - ".join(Globals.currentObjectives)
	$pp0_HUD/Objectives.text = objText
		
	# check the raycast
	if rayNode.is_colliding():
		var coll : Node = rayNode.get_collider()
		
		# print_debug(coll.get_method_list())
		var promptText = coll.get("promptText")
		# print_debug(promptText)
		if promptText != null:
			$pp0_HUD/Prompt.text = promptText
		else:
			$pp0_HUD/Prompt.text = ""
		# check for interaction
		if Input.is_action_just_pressed(interact):
			if coll.has_method("_interact"):
				coll._interact()
	else:
		$pp0_HUD/Prompt.text = ""
	
	setLens()
	
	camNode.global_rotation = headNode.global_rotation
	camNode.global_position = headNode.global_position
	camNode_Colour.global_rotation = headNode.global_rotation
	camNode_Colour.global_position = headNode.global_position

func setLens():
	var depthTx = depthVP.get_texture()
	var screenTx = colourVP.get_texture()
	# lenses[currentLens].setLensParams(depthTx, screenTx)
	currentLens.setLensParams(depthTx, screenTx)
