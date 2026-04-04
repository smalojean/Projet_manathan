extends Node
class_name RaceManager

var last_checkpoint: Checkpoint = null
var is_finished: bool = false

func set_checkpoint(checkpoint: Checkpoint) -> void:
	last_checkpoint = checkpoint

func finish() -> void:
	is_finished = true

func reset() -> void:
	last_checkpoint = null
	is_finished = false
	var finish_line = get_tree().get_first_node_in_group("finish_line")
	if finish_line:
		finish_line.reset_timer()
