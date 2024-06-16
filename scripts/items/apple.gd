class_name Apple
extends RigidBody2D

@onready var animation_player = $AnimationPlayer
@onready var ripe_timer = $RipeTimer
@onready var decay_timer = $DecayTimer

var can_be_collected := false

# Called when the node enters the scene tree for the first time.
func _ready():
	freeze = true
	animation_player.play("grow")
	animation_player.animation_finished.connect(_on_grow_finished)

func _on_grow_finished(anim_name):
	if anim_name == "grow":
		animation_player.animation_finished.disconnect(_on_grow_finished)
		animation_player.play("idle")
		ripe_timer.start()
		decay_timer.start()

func _on_ripe():
	#enable physics to fall down and enbale collectible state
	freeze = false
	apply_torque(randf())
	can_be_collected = true

func _on_decayed():
	apply_impulse(Vector2.LEFT)
	apply_torque(randf())
	queue_free()

func get_item_name():
	return "apple"
