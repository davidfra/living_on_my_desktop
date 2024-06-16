@tool
extends WanderState

@export_category("Search Item")
@export var item_group := "food"
@export var max_distance := 300

# Executes after the state is entered.
func _on_enter(actor, blackboard: Blackboard):
	super._on_enter(actor, blackboard)
	actor = actor as Pixler
	actor.debug_msg("is searching for " + item_group)


# Executes every _process call, if the state is active.
func _on_update(_delta, actor, blackboard: Blackboard):
	super._on_update(_delta, actor, blackboard)
	var item = _find_item(actor)
	if item:
		blackboard.set_value("walk_to_target", item)
		blackboard.set_value("target_type", item_group)
		actor.debug_msg("found item " + item.get_item_name() + " at " + str(item.global_position))


# Executes before the state is exited.
func _on_exit(_actor, _blackboard: Blackboard):
	pass


func _find_item(actor: Pixler):
	for found_item in get_tree().get_nodes_in_group(item_group):
		if found_item.can_be_collected:
			var sdist = actor.global_position.distance_to(found_item.global_position)
			if sdist <= max_distance:
				return found_item as Node2D
	return null
