@tool
class_name Spawner
extends Node2D

@export var active := true
## Defines the Area in which objects are randomly spawned
@export var spawn_area: Rect2:
	set(value):
		spawn_area = value
		queue_redraw()
## If set, a gizmo is drawn in the editor to visualize the Spawn Area
@export var show_in_editor := true:
	set(value):
		show_in_editor = value
		queue_redraw()
## If set, the width of the spawn_area is extended to the actual window width on runtime
@export var extend_horizontally_to_window: bool
@export_range(0.1, 100.0, 0.1) var spawn_rate := 5.0
@export_range(0.0, 1.0, 0.1) var randomize := 0.0
@export var spawned_object: PackedScene:
	set(value):
		spawned_object = value
		update_configuration_warnings()
## If greater than 0: keep a reference to the spawned objects and only spawn new ones
## if the count is below this value
@export var max_alive_objects: int = 0
@export var minimum_distance: int = 0

var spawn_timer := spawn_rate
var _screen_area: Vector2i

func _ready():
	_screen_area = get_window().size
	spawn_timer = spawn_rate

func _process(delta):
	if Engine.is_editor_hint():
		return
	_screen_area = get_window().size
	if extend_horizontally_to_window and not is_equal_approx(spawn_area.position.x + spawn_area.size.x, _screen_area.x):
		spawn_area.size.x = _screen_area.x - spawn_area.position.x
	if not active:
		return
	spawn_timer -= delta
	if  spawn_timer <= 0.0:
		spawn()
		spawn_timer = _next_spawn_time()


func spawn():
	if _count_spawned_objects() >= max_alive_objects:
		return
	var node = spawned_object.instantiate()
	var spawn_pos := _random_position()
	var c = 0
	while not _check_free(spawn_pos) or c > 50:
		spawn_pos = _random_position()
		c += 1
	if c > 50:
		printerr("Could not find a suitable spawn position")
		return
	node.global_position = spawn_pos
	add_child(node)


func _random_position() -> Vector2:
	var x = randf_range(spawn_area.position.x, spawn_area.end.x)
	var y = randf_range(spawn_area.position.y, spawn_area.end.y)
	return Vector2(x, y)

func _check_free(pos: Vector2) -> bool:
	if minimum_distance <= 0:
		return true
	for child in get_children():
		var cpos := child.global_position as Vector2
		if cpos.distance_to(pos) < minimum_distance:
			return false
	return true

func _count_spawned_objects():
	if max_alive_objects == 0:
		return 0
	get_child_count()
	#spawned_objects = spawned_objects.filter(func(e): e != null and e.get_ref() != null and e.get_ref().is_inside_tree())
	return get_child_count()

func _next_spawn_time():
	var next_time = spawn_rate
	if randomize > 0.0:
		var rand := spawn_rate * randomize
		next_time += randf_range(-rand, rand)
	return next_time

# Add custom configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array = []
	if spawned_object == null:
		warnings.append("no spawned object is set")
	return warnings

func _draw():
	if not Engine.is_editor_hint() or not show_in_editor:
		return
	var rect_color = Color.AQUAMARINE
	rect_color.a = 0.6
	draw_rect(spawn_area, rect_color)
