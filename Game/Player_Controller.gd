extends KinematicBody
#Movement controller thanks to
#http://www.willdonnelly.net/blog/2021-05-16-godot-airstrafe-controller/

export var jumpImpulse = 2.2
export var gravity = -5.0
export var groundAcceleration = 30.0
export var groundSpeedLimit = 3.0
export var airAcceleration = 500.0
export var airSpeedLimit = 0.5
export var groundFriction = 0.9

export var mouseSensitivity = 0.1

signal flash
signal addTime

var velocity = Vector3.ZERO
var timedown = Timer.new()
var restartTransform
var restartVelocity

func _ready():
	restartTransform = self.global_transform
	restartVelocity = self.velocity

	pass # Replace with function body.

func _physics_process(delta):
	# Apply gravity, jumping, and ground friction to velocity
	velocity.y += gravity * delta
	if is_on_floor():
		# By using is_action_pressed() rather than is_action_just_pressed()
		# we get automatic bunny hopping.
		if Input.is_action_pressed("jump"):
			velocity.y = jumpImpulse
		else:
			velocity *= groundFriction
	
	# Compute X/Z axis strafe vector from WASD inputs
	var basis = $Pivot/Player_Camera.get_global_transform().basis
	var strafeDir = Vector3(0, 0, 0)
	if Input.is_action_pressed("forward"):
		strafeDir -= basis.z
	if Input.is_action_pressed("backward"):
		strafeDir += basis.z
	if Input.is_action_pressed("strafe_left"):
		strafeDir -= basis.x
	if Input.is_action_pressed("strafe_right"):
		strafeDir += basis.x
	strafeDir.y = 0
	strafeDir = strafeDir.normalized()
	
	# Figure out which strafe force and speed limit applies
	var strafeAccel = groundAcceleration if is_on_floor() else airAcceleration
	var speedLimit = groundSpeedLimit if is_on_floor() else airSpeedLimit
	
	# Project current velocity onto the strafe direction, and compute a capped
	# acceleration such that *projected* speed will remain within the limit.
	var currentSpeed = strafeDir.dot(velocity)
	var accel = strafeAccel * delta
	accel = max(0, min(accel, speedLimit - currentSpeed))
	
	# Apply strafe acceleration to velocity and then integrate motion
	velocity += strafeDir * accel
	velocity = move_and_slide(velocity, Vector3.UP)
	
#	if Input.is_action_pressed("move_fast"):
#		velocity = Vector3.ZERO
#	if Input.is_action_just_released("move_fast"):
#		velocity = -30 * basis.z
	
	if Input.is_action_just_pressed("restart"):
		self.global_transform = restartTransform
		self.velocity = restartVelocity
	
	var point_light = get_node("/root/Spatial/Lights/PlayerLight")
	point_light.transform.origin = transform.origin
	
	#Collision detection
	var slide_count = get_slide_count()
	for i in range(slide_count):
		var collision = get_slide_collision(i)
		var collider_layer = collision.collider.get_collision_layer()
		if collider_layer == 4:
			self.global_transform = restartTransform
			self.velocity = restartVelocity
		if collider_layer == 16:
			collision.collider.set_collision_layer(2)
			emit_signal("addTime")
		if collider_layer == 32:
			var wave = get_node("/root/Spatial/World/Angels/Wave1")
			wave.visible = true
			for _i in wave.get_children():
				_i.set_physics_process(true)
			get_node("/root/Spatial/TEXT").visible = true
			get_node("/root/Spatial/TEXT/TimeLeft").set_process(true)
			emit_signal("flash")
			get_node("/root/Spatial/World/Mistletoe").queue_free()
			get_node("/root/Spatial/World/OuterTree/FakeTop").visible = true
			Engine.time_scale = 0.2
			timedown.connect("timeout", self, "time_finished")
			add_child(timedown)
			timedown.start()
			
	pass
	
func _on_Bottom_Circle_body_entered(body):
	if body == self:
		Engine.time_scale = 0.3
		timedown.start()
		var next_wave = get_node("/root/Spatial/World/Angels/Wave2")
		for _i in next_wave.get_children():
			_i.set_physics_process(true)
	
func time_finished():
	Engine.time_scale = 1
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Pivot.rotate_x(deg2rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouseSensitivity * -1))

		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $Pivot.rotation_degrees.x
		$Pivot.rotation_degrees.x = clamp(yaw, -89, 89)    
