@tool
extends WanderState

@export var max_food_distance := 300

# Executes after the state is entered.
func _on_enter(actor, blackboard: Blackboard):
	super._on_enter(actor, blackboard)
	actor = actor as Pixler
	actor.debug_msg("is hungry and looking for food")


# Executes every _process call, if the state is active.
func _on_update(_delta, actor, blackboard: Blackboard):
	super._on_update(_delta, actor, blackboard)
	var food = _find_food(actor)
	if food:
		blackboard.set_value("walk_to_target", food)
		blackboard.set_value("target_type", "food")
		actor.debug_msg("found food " + food.get_item_name() + " at ", food.global_position)


# Executes before the state is exited.
func _on_exit(_actor, _blackboard: Blackboard):
	pass


func _find_food(actor: Pixler):
	for food_item in get_tree().get_nodes_in_group("food"):
		if food_item.can_be_collected:
			var sdist = actor.global_position.distance_to(food_item.global_position)
			if sdist <= max_food_distance:
				return food_item as Node2D
	return null
