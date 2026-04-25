extends Node

var last_checkpoint: Checkpoint = null
var is_finished: bool = false

var checkpoints_reached: Array[Checkpoint] = []
var total_checkpoints: int = 0

func _ready() -> void:
	# Compte tous les checkpoints présents dans la scène
	total_checkpoints = get_tree().get_nodes_in_group("checkpoint").size()

func set_checkpoint(checkpoint: Checkpoint) -> void:
	# Évite les doublons
	if checkpoint not in checkpoints_reached:
		checkpoints_reached.append(checkpoint)
		last_checkpoint = checkpoint

func init_level() -> void:
	checkpoints_reached.clear()
	total_checkpoints = get_tree().get_nodes_in_group("checkpoint").size()
	print("Total checkpoints:", total_checkpoints)

func can_finish() -> bool:
	return checkpoints_reached.size() == total_checkpoints

func finish() -> void:
	if not can_finish():
		print("Impossible de finir : checkpoints manquants")
		return
	
	is_finished = true

func reset() -> void:
	last_checkpoint = null
	is_finished = false
	checkpoints_reached.clear()

	var finish_line = get_tree().get_first_node_in_group("finish_line")
	if finish_line:
		finish_line.reset_timer()
