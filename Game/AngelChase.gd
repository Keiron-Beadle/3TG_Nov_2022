extends KinematicBody

var player
var kill = false
var normal_speed = 120
var kill_speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Spatial/Player")
	pass # Replace with function body.



func _physics_process(delta):
	var player_pos = player.transform.origin
	var dir = transform.origin.direction_to(player_pos)
	var movement = Vector3.ZERO
	if kill:
		movement += dir * kill_speed * delta
	else:
		movement += dir * normal_speed * delta
	move_and_slide(movement)
	look_at(player_pos, Vector3(0,1,0))
	pass
