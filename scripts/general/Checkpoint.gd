extends Node2D
class_name Checkpoint

signal checkpoint_reached(checkpoint: Checkpoint)

@onready var area: Area2D = $Area2D

var activated: bool = false
var _checkpoint_time: float = 0.0

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if activated:
		return
	if not body.is_in_group("player"):
		return
	activated = true
	body.set_checkpoint(self)
	emit_signal("checkpoint_reached", self)

func set_time(time: float) -> void:
	print("set_time appelé: ", time)
	_checkpoint_time = time
	_show_time_label()
	
func _show_time_label() -> void:
	var total_seconds: int = int(_checkpoint_time)
	var minutes: int = int(floorf(float(total_seconds) / 60.0))
	var seconds: int = total_seconds - (minutes * 60)
	var milliseconds: int = int((_checkpoint_time - float(total_seconds)) * 100)
	var time_str = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

	var label = Label.new()
	label.text = time_str
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.2))

	# position en coordonnées monde au centre du checkpoint
	var shape = area.get_node("CollisionShape2D")
	label.position = shape.global_position - Vector2(20, 32)

	# ajoute directement à la scène pour suivre le monde
	get_tree().current_scene.add_child(label)

	await get_tree().create_timer(3.0).timeout
	label.queue_free()

func get_spawn_position() -> Vector2:
	var shape = area.get_node("CollisionShape2D")
	var half_height: float = 0.0
	if shape.shape is RectangleShape2D:
		half_height = shape.shape.size.y / 2.0
	elif shape.shape is CircleShape2D:
		half_height = shape.shape.radius
	elif shape.shape is CapsuleShape2D:
		half_height = shape.shape.height / 2.0
	return area.global_position + shape.position + Vector2(0, half_height)

func reset() -> void:
	activated = false
	_checkpoint_time = 0.0
