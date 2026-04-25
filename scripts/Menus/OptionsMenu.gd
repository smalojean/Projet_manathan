extends Control

# Signal envoyé quand on ferme Options
signal closed

func _ready():
	$CenterContainer/VBoxContainer/Video.pressed.connect(_on_video_pressed)
	$CenterContainer/VBoxContainer/Sound.pressed.connect(_on_sound_pressed)
	$CenterContainer/VBoxContainer/Controls.pressed.connect(_on_controls_pressed)
	$CenterContainer/VBoxContainer/Back.pressed.connect(_on_back_pressed)


# --- Boutons ---

func _on_video_pressed():
	print("Video pressed")

func _on_sound_pressed():
	print("Sound pressed")


# --- Ouvrir ControlsMenu ---

func _on_controls_pressed():
	var controls_scene = load("res://scenes/menus/controls_menu.tscn").instantiate()
	
	# Connexion du signal de retour
	controls_scene.closed.connect(_on_controls_closed)
	
	# Ajout au même niveau (MenuContainer)
	get_parent().add_child(controls_scene)
	
	# Cache entièrement Options
	hide()


# --- Retour depuis ControlsMenu ---

func _on_controls_closed():
	show()


# --- Retour vers MainMenu ---

func _on_back_pressed():
	emit_signal("closed")  # informe MainMenu
	queue_free()           # supprime OptionsMenu
