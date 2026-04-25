extends Control

# Signal pour notifier OptionsMenu
signal closed

func _ready():
	$CenterContainer/VBoxContainer/Keyboard.toggled.connect(_on_keyboard_toggled)
	$CenterContainer/VBoxContainer/Controller.toggled.connect(_on_controller_toggled)
	$CenterContainer/VBoxContainer/Back.pressed.connect(_on_back_pressed)


# --- Inputs ---

func _on_keyboard_toggled(button_pressed):
	print("Keyboard toggled:", button_pressed)

func _on_controller_toggled(button_pressed):
	print("Controller toggled:", button_pressed)


# --- Retour vers OptionsMenu ---

func _on_back_pressed():
	emit_signal("closed")  # informe OptionsMenu
	queue_free()           # ferme ControlsMenu
