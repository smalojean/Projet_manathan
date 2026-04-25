extends Area2D

@export var secrets_layer: TileMapLayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(secrets_layer, "modulate:a", 0.0, 0.3)
		print("entered")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(secrets_layer, "modulate:a", 1.0, 0.3)
		print("exited")
