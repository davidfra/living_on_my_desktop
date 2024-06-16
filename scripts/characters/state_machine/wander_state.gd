@tool
class_name WanderState
extends FSMState


# Executes after the state is entered.
func _on_enter(actor, _blackboard: Blackboard):
	actor = actor as Pixler
	actor.animated_sprite.play("walk")
	actor.debug_msg("is wandering around")


# Executes every _process call, if the state is active.
func _on_update(delta, actor, _blackboard: Blackboard):
	actor = actor as Pixler
	actor.position.x += actor.SPEED * actor.direction * delta
	
	if actor.is_hitting_bounds():
		actor.turn()


# Executes before the state is exited.
func _on_exit(_actor, _blackboard: Blackboard):
	pass

