extends Label

signal KILL

var time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta
	if time == 0:
		emit_signal("KILL")
	text = str(stepify(time, 0.01)) + " s"
	pass
	
func _on_player_collide_platform():
	pass
