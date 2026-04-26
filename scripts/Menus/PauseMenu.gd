extends Control
class_name PauseMenu

var is_paused: bool = false

@onready var menu_container: Control = $MenuContainer

func _ready() -> void:
	print("PauseMenu READY")

	menu_container.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	set_anchors_preset(Control.PRESET_FULL_RECT)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Button 6"):
		print("Button 6")
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused

	menu_container.visible = is_paused
	get_tree().paused = is_paused

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_CAPTURED
