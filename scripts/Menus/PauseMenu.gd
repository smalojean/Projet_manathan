extends Control
class_name PauseMenu

var is_paused: bool = false

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeRace
@onready var reset_button: Button = $CenterContainer/VBoxContainer/ResetRace
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackToMenu

func _ready() -> void:
	visible = false
	set_anchors_preset(Control.PRESET_FULL_RECT)
	global_position = Vector2.ZERO
	# Le menu lui-même doit continuer à fonctionner même en pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Tous les contrôles UI restent interactifs pendant la pause
	for child in get_children():
		_set_process_mode_recursive(child, Node.PROCESS_MODE_WHEN_PAUSED)

	resume_button.pressed.connect(_on_resume_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	back_button.pressed.connect(_on_back_to_menu_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Button 6"):
		print("Button 6")
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused

	visible = is_paused
	get_tree().paused = is_paused

	Input.mouse_mode = (
		Input.MOUSE_MODE_VISIBLE
		if is_paused
		else Input.MOUSE_MODE_CAPTURED
	)

	if is_paused:
		resume_button.grab_focus()

####
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_reset_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("uid://b8y0c1lyegdpd")

func _set_process_mode_recursive(node: Node, mode: Node.ProcessMode) -> void:
	node.process_mode = mode
	for child in node.get_children():
		_set_process_mode_recursive(child, mode)
