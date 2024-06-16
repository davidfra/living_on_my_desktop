@tool
extends FSMTransition

@export_category("Expected Target")
@export_enum("food", "tool", "material", "pixler") var target_type: String = "food"

# Executed when the transition is taken.
func _on_transition(_delta, _actor, _blackboard: Blackboard):
	pass


# Evaluates true, if the transition conditions are met.
func is_valid(_actor, blackboard: Blackboard):
	var target = blackboard.get_value("target_reached")
	var type = blackboard.get_value("target_type")
	return target != null and type == target_type
