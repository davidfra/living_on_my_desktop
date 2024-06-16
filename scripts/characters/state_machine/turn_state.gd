@tool
extends FSMState


# Executes after the state is entered.
func _on_enter(actor, _blackboard: Blackboard):
	actor = actor as Pixler
	actor.turn()
	actor.debug_msg("turned around")
