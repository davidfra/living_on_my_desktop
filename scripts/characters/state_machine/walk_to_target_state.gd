@tool
extends WanderState


# Executes after the state is entered.
func _on_enter(actor, blackboard: Blackboard):
	var target = blackboard.get_value("walk_to_target") as Node2D
	var target_position = target.global_position if target else Vector2.ZERO
	actor = actor as Pixler
	
	if target_position:
		actor.animated_sprite.play("walk")
		actor.debug_msg("is walking to " + target.get_item_name())


# Executes every _process call, if the state is active.
func _on_update(_delta, actor, blackboard: Blackboard):
	actor = actor as Pixler
	var target = blackboard.get_value("walk_to_target") as Node2D
	if target == null or not target.is_inside_tree():
		blackboard.remove_value("walk_to_target")
		blackboard.remove_value("target_type")
		return
		
	var target_position = target.global_position
	
	var dist_x = target_position.x - actor.global_position.x
	actor.direction = Pixler.Direction.LEFT if dist_x < 0 else Pixler.Direction.RIGHT
	if abs(dist_x) > 5:
		# call super to walk in that direction:
		super._on_update(_delta, actor, blackboard)
	else:
		blackboard.set_value("target_reached", target)


# Executes before the state is exited.
func _on_exit(_actor, blackboard: Blackboard):
	blackboard.remove_value("walk_to_target")

