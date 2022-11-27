extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("/root/Spatial/TEXT/TimeLeft").set_process(false)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

