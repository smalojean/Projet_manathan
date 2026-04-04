extends Node2D
class_name Spawner

@export var player_scene: PackedScene
@export var auto_spawn: bool = true

func _ready():
	if auto_spawn:
		spawn()

func spawn() -> CharacterBody2D:
	var player = player_scene.instantiate()
	player.global_position = global_position + Vector2(0, -13)
	get_tree().current_scene.call_deferred("add_child", player)
	call_deferred("_start_countdown", player)
	return player

func _start_countdown(player: CharacterBody2D) -> void:
	# bloque le joueur
	player.set_physics_process(false)
	player.set_process_input(false)

	var canvas = CanvasLayer.new()
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 80)
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	canvas.add_child(label)
	get_tree().root.add_child(canvas)

	# décompte
	for i in [3, 2, 1]:
		label.text = str(i)
		label.modulate = Color(1.0, 1.0, 1.0, 1.0)
		var tween = get_tree().create_tween()
		tween.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.3), 0.8)
		await get_tree().create_timer(1.0).timeout

	# GO!
	label.text = "GO!"
	label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.3))
	label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var tween_go = get_tree().create_tween()
	tween_go.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.8)

	# débloque le joueur et démarre le timer
	player.set_physics_process(true)
	player.set_process_input(true)
	var finish_line = get_tree().get_first_node_in_group("finish_line")
	if finish_line:
		finish_line.reset_timer()

	await get_tree().create_timer(0.8).timeout
	canvas.queue_free()
