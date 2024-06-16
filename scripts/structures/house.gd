class_name House
extends Node2D

@onready var animation_player = %AnimationPlayer

signal door_changed(open: bool)

var _door_open = false

func _ready():
	animation_player.play("door_closed")

func open_door():
	if not _door_open and not animation_player.is_playing():
		animation_player.play("door_open")
		await animation_player.animation_finished
		_door_open = true
		door_changed.emit(_door_open)

func close_door():
	if _door_open and not animation_player.is_playing():
		animation_player.play("door_close")
		await animation_player.animation_finished
		_door_open = false
		door_changed.emit(_door_open)

func is_door_open():
	return _door_open

func open_and_close_door():
	if not _door_open:
		open_door()
		await door_changed
		await get_tree().create_timer(0.5).timeout
		close_door()

# for testing:
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		open_and_close_door()
