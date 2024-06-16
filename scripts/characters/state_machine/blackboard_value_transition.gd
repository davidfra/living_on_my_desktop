@tool
extends FSMTransition

@export_category("Blackboard Value")
@export var value_name: String
@export var transition_if_missing := false
@export var compare_value: bool = false
@export var value_to_match: String

# Executed when the transition is taken.
func _on_transition(_delta, _actor, _blackboard: Blackboard):
	pass


# Evaluates true, if the transition conditions are met.
func is_valid(_actor, blackboard: Blackboard) -> bool:
	var value = blackboard.get_value(value_name)
	if transition_if_missing:
		return value == null
	if not compare_value:
		return value != null
	return str(value) == value_to_match


# Add custom configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array = []

	warnings.append_array(super._get_configuration_warnings())

	if not value_name:
		warnings.append("BlackboardValueTransition has no value_name set.")
	
	if transition_if_missing and compare_value:
		warnings.append("Either set 'transition_if_missing' or 'compare_value', not both.")
	
	if compare_value and value_to_match == null:
		warnings.append("'compare_value' is checked but no 'value_to_match' is set.")

	return warnings
