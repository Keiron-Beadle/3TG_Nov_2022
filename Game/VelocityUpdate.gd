extends Label


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Spatial/Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = player.velocity.length()
	text = str(stepify(speed,0.01)) + " M/S"
	pass
