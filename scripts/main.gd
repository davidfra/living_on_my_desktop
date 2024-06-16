extends Node2D

@export var show_pixler_debug := false

const TASKBAR_HEIGHT = 50
var resolution

# Called when the node enters the scene tree for the first time.
func _ready():
	_resize_to_fit_screen()


func _resize_to_fit_screen():
	resolution = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	var win = get_window()
	win.size.x = resolution.x
	win.position.x = 0
	win.position.y = resolution.y - win.size.y - TASKBAR_HEIGHT
	# win.mouse_passthrough = true # not working
	#win.mouse_passthrough_polygon = %ClickableRect.polygon # will hide the rest of the window
	# Instead allow setting: win.always_on_top = true/false
	
	# adjust the ground line as well:
	%GroundLine.points[1].x = resolution.x
