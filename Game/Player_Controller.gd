extends KinematicBody

onready var camera = $Pivot/Player_Camera

const gravity = -30;
var max_speed = 8;
var mouse_sens = 0.002;

var velocity = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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
	wish_dir = wish_dir.normalize()
	return wish_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#Rotate Bodies Y
		rotate_y(-event.relative.x * mouse_sens) 
		#Rotate Pivot X (Don't want model to rotate Y)
		$Pivot.rotate_x(-event.relative.y * mouse_sens)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
