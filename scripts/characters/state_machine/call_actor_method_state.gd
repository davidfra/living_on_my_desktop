@tool
extends FSMState

@export_category("Call Method")
@export var method: String:
	set(value):
		method = value
		update_configuration_warnings()
@export var description = "performs some action"

# Executes after the state is entered.
func _on_enter(actor, _blackboard: Blackboard):
	actor = actor as Pixler
	if not actor.has_method(method):
		printerr("Actor has no method called: ", method)
		return
	actor.call(method)
	actor.debug_msg(description)


# Executes every _process call, if the state is active.
func _on_update(_delta, _actor, _blackboard: Blackboard):
	pass


# Executes before the state is exited.
func _on_exit(_actor, _blackboard: Blackboard):
	pass

# Add custom configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array = []

	warnings.append_array(super._get_configuration_warnings())

	if not method:
		warnings.append("The method name to call must be set.")
	
	return warnings
