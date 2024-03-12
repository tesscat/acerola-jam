extends CharacterBody3D


const SPEED = 4.0
const JUMP_VELOCITY = 45
@export var panSpeed = 0.012
const TERMINAL_SPEED = 25

var last_v = Vector3(0, 0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 10
var glitchIntens = 0.0
var random = RandomNumberGenerator.new()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * panSpeed)
		$Camera3D.rotate_x(-event.relative.y * panSpeed)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):

	glitchIntens += ((velocity - last_v).length())/(2*TERMINAL_SPEED)
	print_debug("GI: ", glitchIntens)
		
	last_v = velocity
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y < -TERMINAL_SPEED: velocity.y = -TERMINAL_SPEED

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gm_left", "gm_right", "gm_forward", "gm_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x += direction.x * SPEED
		velocity.z += direction.z * SPEED
	else:
		velocity.x += move_toward(velocity.x, 0, SPEED)
		velocity.z += move_toward(velocity.z, 0, SPEED)
	
	velocity *= 0.5
	
	glitchIntens = 1/(1/glitchIntens + delta)
	if Input.is_action_just_pressed("ui_page_up"):
		glitchIntens = 0.6
		var neg = random.randi_range(0, 1)
		var val = random.randf_range(0.6, 0.8)
		$pp2_GlitchMap/ColorRect.material.set_shader_parameter("rSeed", Time.get_ticks_msec())
		$pp2_GlitchMap/ColorRect.material.set_shader_parameter("warpInp", Vector2(pow(-1, neg) * val, 0.0))
	if Input.is_action_just_pressed("ui_page_down"):
		glitchIntens = 1.0
		var neg = random.randi_range(0, 1)
		var val = random.randf_range(0.6, 0.8)
		$pp2_GlitchMap/ColorRect.material.set_shader_parameter("rSeed", Time.get_ticks_msec())
		$pp2_GlitchMap/ColorRect.material.set_shader_parameter("warpInp", Vector2(pow(-1, neg) * val, 0.0))
	
	$pp2_GlitchMap/ColorRect.material.set_shader_parameter("invIntensity", 1 - clamp(glitchIntens - 0.3, 0, 1))
	$pp2_GlitchMap/ColorRect.material.set_shader_parameter("glitchOverlay", glitchIntens/3.0)
	$pp2_GlitchMap/ColorRect.material.set_shader_parameter("warpStrength", pow(glitchIntens - 0.6, 3) if glitchIntens > 0.6 else 0.0)
	$pp1_VBars/ColorRect.material.set_shader_parameter("colourSplit", 0.2 + glitchIntens/2.0)
	$pp1_VBars/ColorRect.material.set_shader_parameter("noiseIntensity_u", 0.2 + glitchIntens/1.4)
	$pp1_VBars/ColorRect.material.set_shader_parameter("barsIntens", -tanh((3/glitchIntens)-5.5)/3 + 0.6)

	move_and_slide()
