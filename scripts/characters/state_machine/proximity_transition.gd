@tool
extends FSMTransition

@export_category("Proximity Settings")
@export_enum("food", "tool", "material", "pixler") var object_type = "pixler"
@export_range(0, 500, 1) var max_distance: int = 30
## Prevents this transition to fire again within the given delay in seconds
@export_range(0.0, 5.0, 0.1) var transition_delay = 2.0
var last_transition: int = 0

# Executed when the transition is taken.
func _on_transition(_delta, _actor, _blackboard: Blackboard):
	last_transition = Time.get_ticks_msec()


# Evaluates true, if the transition conditions are met.
func is_valid(actor, blackboard: Blackboard):
	if transition_delay and last_transition:
		var since_last = (Time.get_ticks_msec() - last_transition) / 1000
		if since_last < transition_delay:
			return false
	var my_pos = actor.global_position
	for obj in get_tree().get_nodes_in_group(object_type):
		var other_pos = obj.global_position
		if actor != obj and my_pos.distance_to(other_pos) <= max_distance:
			blackboard.set_value("proximity_obj", obj)
			return true
	return false
