extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var frame_count = 0
var cur_flashscreen = 0
var cur_flashes = 0
var flash_screens = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	flash_screens.append($Thing1)
	flash_screens.append($Thing2)
	flash_screens.append($Thing3)
	flash_screens.append($Thing3)
	get_node("/root/Spatial/Player").connect("flash", self, "on_flash_screen")
	#Engine.time_scale = 0.25

func on_flash_screen():
	set_process(true)
	pass

func _process(delta):
	if(frame_count > 0.1):
		frame_count = 0
		cur_flashes += 1
		
		var flashscreen = flash_screens[cur_flashscreen]
		flashscreen.visible = not flashscreen.visible
		
		if(cur_flashes == 4):
			cur_flashes = 0
			cur_flashscreen += 1
			
			if cur_flashscreen >= len(flash_screens):
				queue_free()
				set_process(false)
	
	frame_count += delta
