extends Node
class_name PlayerAnimation

var sprite: AnimatedSprite2D
var last_animation: String = ""
var is_landing: bool = false

func setup(p_sprite: AnimatedSprite2D) -> void:
	sprite = p_sprite

func play(anim: String) -> void:
	if last_animation == anim:
		return
	last_animation = anim
	sprite.play(anim)
	if anim != "idle":
		sprite.animation_finished.connect(
			func():
				sprite.pause()
				sprite.frame = sprite.sprite_frames.get_frame_count(anim) - 1,
			CONNECT_ONE_SHOT)

func update(body: CharacterBody2D, wall, direction: float, was_on_floor: bool) -> void:
	if is_landing:
		return
	if wall.is_wall_sliding(body):
		if sprite.animation != "wall_slide_right":
			play("wall_slide_right")
		sprite.flip_h = body.get_wall_normal().x > 0
		sprite.rotation_degrees = 0
	elif not body.is_on_floor():
		_update_air(direction, body.velocity.y)
	else:
		sprite.rotation_degrees = 0
		if not was_on_floor:
			is_landing = true
			play("reception")
			sprite.animation_finished.connect(_on_landing_finished, CONNECT_ONE_SHOT)
		elif direction != 0:
			play("move_right")
		else:
			play("idle")

func _update_air(direction: float, vel_y: float) -> void:
	if vel_y < 0:
		play("jump")
	else:
		if sprite.animation != "falling" and sprite.animation != "jump":
			play("falling")
		elif sprite.animation == "jump" and vel_y >= 0:
			if not sprite.is_playing():
				play("falling")
	if direction > 0:
		sprite.rotation_degrees = 45 if vel_y < 0 else -45
	elif direction < 0:
		sprite.rotation_degrees = -45 if vel_y < 0 else 45
	else:
		sprite.rotation_degrees = 0

func _on_landing_finished() -> void:
	is_landing = false
