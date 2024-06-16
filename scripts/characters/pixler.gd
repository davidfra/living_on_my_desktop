class_name Pixler
extends Node2D

enum Direction{
	LEFT = -1,
	RIGHT = 1
}

const SPEED = 80
const HUNGER_GROWTH := 1.0

var walk_area: Vector2i
@export var direction := Direction.RIGHT

@export var saturation := 100.0
var hungry := false:
	set(value):
		hungry = value
		if bubble_hungry:
			bubble_hungry.visible = value

var held_item: Node2D

@onready var animated_sprite := %AnimatedSprite as AnimatedSprite2D
@onready var finite_state_machine = %FiniteStateMachine
@onready var debug_label = %DebugLabel

@onready var bubble_hungry = $BubbleHungry
@onready var bubble_greet = $BubbleGreet


# Called when the node enters the scene tree for the first time.
func _ready():
	walk_area = get_window().size
	finite_state_machine.start()
	bubble_hungry.visible = false
	self.name = _generate_name()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk_area = get_window().size
	animated_sprite.flip_h = (direction == Direction.LEFT)
	_get_hungry(delta)

func is_hitting_bounds() -> bool:
	return direction == Direction.RIGHT and position.x > walk_area.x or direction == Direction.LEFT and position.x < 0

func turn():
	direction = Direction.LEFT if (direction == Direction.RIGHT) else Direction.RIGHT

func greet():
	if bubble_greet.visible:
		return
	bubble_greet.visible = true
	await get_tree().create_timer(1.0).timeout
	bubble_greet.visible = false

func debug_msg(msg: String):
	if not get_tree().current_scene.show_pixler_debug:
		debug_label.visible = false
		return
	debug_label.visible = true
	debug_label.text = name + " " + msg

func _get_hungry(delta):
	if saturation > 0:
		saturation -= HUNGER_GROWTH * delta
	if saturation <= 20.0:
		hungry = true
		finite_state_machine.fire_event("hungry")
	elif saturation >= 30.0:
		hungry = false



const VOCALS :=  ["a", "e", "i", "o", "u", "y"]
const CONSONANTS := ["b", "c", "d", "f", "g", "h","j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]

## Generate a random 3 letter name:
func _generate_name():
	var _name = ""
	if randi() % 2:
		_name = VOCALS.pick_random().to_upper() + CONSONANTS.pick_random() + VOCALS.pick_random()
	else:
		_name = CONSONANTS.pick_random().to_upper() + VOCALS.pick_random() + CONSONANTS.pick_random()
	return _name
