extends Node2D
class_name FinishLine

signal level_completed(time: float)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var _start_time: float = 0.0
var _finished: bool = false
	
func _ready():
	RaceManager.init_level()
	_start_time = Time.get_ticks_msec() / 1000.0
	area.body_entered.connect(_on_body_entered)
	animated_sprite.play("idle") # 👈 ici
	var checkpoints = get_tree().get_nodes_in_group("checkpoint")
	print("checkpoints trouvés: ", checkpoints.size())
	for checkpoint in checkpoints:
		checkpoint.checkpoint_reached.connect(_on_checkpoint_reached)

func _on_checkpoint_reached(checkpoint: Checkpoint) -> void:
	var elapsed = (Time.get_ticks_msec() / 1000.0) - _start_time
	checkpoint.set_time(elapsed)

func _on_body_entered(body: Node2D):
	if _finished:
		return
	if not body.is_in_group("player"):
		return

	var race_manager = get_node("/root/RaceManager") # adapte si besoin
	
	if not race_manager.can_finish():
		print("Tous les checkpoints ne sont pas atteints")
		return

	_finished = true
	var elapsed = (Time.get_ticks_msec() / 1000.0) - _start_time
	emit_signal("level_completed", elapsed)
	_trigger_finish(body, elapsed)

func _trigger_finish(player: CharacterBody2D, elapsed: float) -> void:
	player.finish()
	await get_tree().create_timer(0.0).timeout
	
	_show_finish_screen(elapsed)

func _show_finish_screen(time: float):
	var total_seconds: int = int(time)
	var minutes: int = int(floorf(float(total_seconds) / 60.0))
	var seconds: int = total_seconds - (minutes * 60)
	var milliseconds: int = int((time - float(total_seconds)) * 100)
	var time_str = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

	var overlay = CanvasLayer.new()
	var panel = PanelContainer.new()
	var vbox = VBoxContainer.new()
	var title = Label.new()
	var time_label = Label.new()
	var restart_label = Label.new()

	title.text = "NIVEAU TERMINÉ!"
	time_label.text = "Temps : " + time_str
	restart_label.text = "Appuie sur Entrée pour recommencer"

	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	title.add_theme_font_size_override("font_size", 32)
	time_label.add_theme_font_size_override("font_size", 24)
	restart_label.add_theme_font_size_override("font_size", 14)

	vbox.add_child(title)
	vbox.add_child(time_label)
	vbox.add_child(restart_label)
	panel.add_child(vbox)
	overlay.add_child(panel)
	add_child(overlay)
	panel.set_anchors_preset(Control.PRESET_CENTER)

	await _wait_for_restart()
	RaceManager.reset()
	overlay.queue_free()
	get_tree().reload_current_scene()

func _wait_for_restart() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			return

func reset_timer() -> void:
	_start_time = Time.get_ticks_msec() / 1000.0
	_finished = false
