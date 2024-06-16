class_name GrowingTree
extends Node2D

@export_range(0.1, 1.0, 0.01) var growth = 0.1:
	get:
		return growth
	set(value):
		growth = value
		if animation_player:
			animation_player.seek(growth, true)

@export_range(0.0, 0.5, 0.01) var growth_rate = 0.02

@export var Fruit: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var spawn_timer := %SpawnTimer as Timer
@onready var fruit_spawns = $FruitSpawns


var spawn_positions: Array[Vector2]
var last_spawn_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("grow")
	animation_player.pause()
	animation_player.seek(growth, true)
	for spawn in fruit_spawns.get_children():
		spawn_positions.append(spawn.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_fully_grown() and growth_rate > 0.0:
		growth += growth_rate * delta
	elif is_fully_grown() and spawn_timer.is_stopped():
		spawn_timer.start()

func is_fully_grown() -> bool:
	return growth >= 1.0

func spawn_fruit():
	if not Fruit:
		return
	var spawn_pos:Vector2 = spawn_positions.pick_random()
	# pick a random spawn position, but not the same position twice:
	while(spawn_pos == last_spawn_pos):
		spawn_pos = spawn_positions.pick_random()
	last_spawn_pos = spawn_pos
	# add some random offset (avoids stacking fruits on top of each other):
	spawn_pos += Vector2(randi_range(-3, 3), randi_range(-3, 3))
	var fruit = Fruit.instantiate()
	add_child(fruit)
	fruit.global_position = spawn_pos
	# randomize time until next spawn:
	spawn_timer.wait_time = randf_range(3.0, 15.0)

