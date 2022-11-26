extends KinematicBody

onready var camera = $Pivot/Player_Camera

const gravity = -14
var mouse_sens = 0.001

var velocity = Vector3()
var jump_add = 0.34
var speed = 3
var max_add = 1
var max_dec = 3
var max_speed = 100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var wish_dir = Vector3()
	if Input.is_action_pressed("forward"):
		wish_dir += -global_transform.basis.z
	if Input.is_action_pressed("backward"):
		wish_dir += global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		wish_dir += -global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		wish_dir += global_transform.basis.x
	wish_dir = wish_dir.normalized()
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = 6
	else:
		if is_on_floor():
			velocity.y = 0
	if not is_on_floor():
		if wish_dir.length_squared() == 0:
			wish_dir = velocity.normalized()

	return wish_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#Rotate Bodies Y
		rotate_y(-event.relative.x * mouse_sens) 
		#Rotate Pivot X (Don't want model to rotate Y)
		$Pivot.rotate_x(-event.relative.y * mouse_sens)
		#Clamp X rotation between these values so we can't invert the view. 
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		var viewport = get_viewport()
		#viewport.warp_mouse(viewport.get_rect().size)

func _physics_process(delta):
	velocity.y += gravity * delta
	var wish_dir = get_input()
	var wish_dirV2 = Vector2(wish_dir.x, wish_dir.z)
	var vel_dirV2 = Vector2(velocity.x, velocity.z).normalized()
	var angleBetweenVelAndWish = wish_dirV2.angle_to(vel_dirV2)
	
	var speedIncrease = smoothstep(0.01, 0.698, angleBetweenVelAndWish)
	var speedDecrease = smoothstep(0.699, 1.0472, angleBetweenVelAndWish)
	
	speed = clamp(speedIncrease * max_add + speedDecrease * max_dec,3,max_speed)
	
	var wish_vel = wish_dir * speed

	velocity.x = wish_vel.x
	velocity.z = wish_vel.z
	var label = get_node("/root/Spatial/UI/Velocity_Label")
	label.text = "Velocity: " + str(velocity.length())
	velocity = move_and_slide(velocity, Vector3.UP, true)
