extends Node
class_name PlayerAnimation

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND,
	WALL_SLIDE,
	DASH
}

var sprite: AnimatedSprite2D
var state: State = State.IDLE
var is_locked: bool = false # pour les animations non interruptibles

func setup(p_sprite: AnimatedSprite2D) -> void:
	sprite = p_sprite

func set_state(new_state: State) -> void:
	if state == new_state:
		return

	# Bloque si une anim non interruptible est en cours
	if is_locked:
		return

	state = new_state
	_play_state()

func _play_state() -> void:
	match state:
		State.IDLE:
			sprite.play("idle")

		State.RUN:
			sprite.play("move_right")

		State.JUMP:
			sprite.play("jump")
			_lock_until_finished()

		State.FALL:
			sprite.play("falling")

		State.LAND:
			sprite.play("reception")
			_lock_until_finished()

		State.WALL_SLIDE:
			sprite.play("wall_slide_right")
		
		State.DASH:
			sprite.play("dash")


func _lock_until_finished() -> void:
	is_locked = true
	sprite.animation_finished.connect(_unlock, CONNECT_ONE_SHOT)

func _unlock() -> void:
	is_locked = false

func update(body: CharacterBody2D, wall, direction: float, was_on_floor: bool) -> void:
	# WALL SLIDE
	if wall.is_wall_sliding(body):
		set_state(State.WALL_SLIDE)
		sprite.flip_h = body.get_wall_normal().x > 0
		sprite.rotation_degrees = 0
		return

	# AIR
	if not body.is_on_floor():
		if body.velocity.y < 0:
			set_state(State.JUMP)
		else:
			set_state(State.FALL)

		# rotation visuelle
		if direction > 0:
			sprite.rotation_degrees = 45 if body.velocity.y < 0 else -45
		elif direction < 0:
			sprite.rotation_degrees = -45 if body.velocity.y < 0 else 45
		else:
			sprite.rotation_degrees = 0

		return

	# SOL
	sprite.rotation_degrees = 0

	if not was_on_floor:
		set_state(State.LAND)
	elif direction != 0:
		set_state(State.RUN)
	else:
		set_state(State.IDLE)
