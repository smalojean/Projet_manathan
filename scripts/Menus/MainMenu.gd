extends Control

func _ready():
	# Connexion des boutons du menu principal
	$CenterContainer/VBoxContainer/Tutorial.pressed.connect(_on_tutorial_pressed)
	$CenterContainer/VBoxContainer/SpeedRun.pressed.connect(_on_speed_run_pressed)
	$CenterContainer/VBoxContainer/Campaign.pressed.connect(_on_campaign_pressed)
	$CenterContainer/VBoxContainer/Options.pressed.connect(_on_options_pressed)
	$CenterContainer/VBoxContainer/ExitGame.pressed.connect(_on_exit_game_pressed)


# --- Boutons principaux ---

func _on_tutorial_pressed():
	RaceManager.reset()
	get_tree().change_scene_to_file("uid://d2yklxp1pbh4c")

func _on_speed_run_pressed():
	print("SpeedRun pressed")

func _on_campaign_pressed():
	print("Campaign pressed")


# --- Ouverture du menu Options ---

func _on_options_pressed():
	var options_scene = load("res://scenes/menus/options_menu.tscn").instantiate()
	
	# On écoute la fermeture du menu Options
	options_scene.closed.connect(_on_options_closed)
	
	# Ajout dans le container global
	$MenuContainer.add_child(options_scene)
	
	# Cache le menu principal
	$CenterContainer.hide()


# --- Retour depuis Options ---

func _on_options_closed():
	$CenterContainer.show()


# --- Quitter le jeu ---

func _on_exit_game_pressed():
	get_tree().quit()
