extends Node2D

enum MenuOpt {
	ON_TOP,
	OTHER,
	QUIT
}

const DEFAULT_BOTTOM_MARGIN := 50

@export var show_pixler_debug := false
@export var window_bottom_margin: int:
	set(value):
		window_bottom_margin = value
		_apply_bottom_margin(value)

var resolution

@onready var popup_menu = %PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	_resize_to_fit_screen()
	popup_menu.add_check_item("Allways on top", MenuOpt.ON_TOP)
	popup_menu.set_item_checked(MenuOpt.ON_TOP, true)
	popup_menu.add_item("Other settings", MenuOpt.OTHER)
	popup_menu.add_item("Exit", MenuOpt.QUIT)
	popup_menu.id_pressed.connect(_on_popup_item_selected)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		
		popup_menu.popup(Rect2i(event.global_position.x, 0, 100, get_window().size.y))

func _on_popup_item_selected(id: int):
	if id == MenuOpt.ON_TOP:
		var was_checked = popup_menu.is_item_checked(id)
		get_window().always_on_top = !was_checked
		popup_menu.set_item_checked(MenuOpt.ON_TOP, !was_checked)
	elif id == MenuOpt.QUIT:
		get_tree().quit()

func _resize_to_fit_screen():
	resolution = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	var win = get_window()
	win.size.x = resolution.x
	win.position.x = 0
	window_bottom_margin = DEFAULT_BOTTOM_MARGIN
	
	# adjust the ground line as well:
	%GroundLine.points[1].x = resolution.x

func _apply_bottom_margin(value):
	var win = get_window()
	win.position.y = resolution.y - win.size.y - value

