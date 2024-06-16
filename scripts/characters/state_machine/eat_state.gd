@tool
extends FSMState


# Executes after the state is entered.
func _on_enter(actor, blackboard: Blackboard):
	actor = actor as Pixler
	var target = blackboard.get_value("target_reached") as Node2D
	var type = blackboard.get_value("target_type")
	if target == null or not target.is_inside_tree():
		printerr("target food is not set or invalid")
		_clear_target(blackboard)
		return
	if not type == "food" or not target.is_in_group("food"):
		printerr("target is no food object ", target)
		_clear_target(blackboard)
		return
	# Eat the object:
	actor.debug_msg("is eating a(n) " + target.get_item_name())
	target.queue_free()
	actor.saturation = 100.0
	_clear_target(blackboard)


func _clear_target(blackboard: Blackboard):
	blackboard.remove_value("target_reached")
	blackboard.remove_value("target_type")

# Executes every _process call, if the state is active.
func _on_update(_delta, _actor, _blackboard: Blackboard):
	pass


# Executes before the state is exited.
func _on_exit(_actor, _blackboard: Blackboard):
	pass

