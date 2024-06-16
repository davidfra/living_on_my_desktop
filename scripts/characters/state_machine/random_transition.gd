@tool
extends FSMTransition

@export_range(0, 500, 1) var random_factor: int = 100

# Executed when the transition is taken.
func _on_transition(_delta, _actor, _blackboard: Blackboard):
	pass


# Evaluates true, if the transition conditions are met.
func is_valid(_actor, _blackboard: Blackboard):
	return not randi() % random_factor
