extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("/root/Spatial/TEXT/TimeLeft").set_process(false)
	
	var angelWaves = get_node("/root/Spatial/World/Angels")
	for _i in angelWaves.get_children():
		for _j in _i.get_children():
			_j.set_physics_process(false)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

