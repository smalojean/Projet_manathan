extends Node
class_name MovementComponent

@export var speed: float = 100.0
@export var jump_velocity: float = -250.0
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.15

var input: InputComponent

# --- dash
var dash_action: String = "Button 2"
var dash_available: bool = true
var dash_active: bool = false
var dash_timer: float = 0.0
var dash_velocity: Vector2 = Vector2.ZERO
var _post_dash_momentum: float = 0.0
var _post_dash_timer: float = 0.0
var _post_dash_duration: float = 0.25

func setup(p_input: InputComponent) -> void:
	input = p_input

func handle_movement(body: CharacterBody2D, wall: WallComponent = null) -> float:
	if body.is_on_floor() and not dash_active:
		dash_available = true

	if dash_active:
		dash_timer -= get_process_delta_time()
		body.velocity.x = dash_velocity.x
		body.velocity.y = dash_velocity.y
		if dash_timer <= 0.0:
			dash_active = false
			body.velocity.x = dash_velocity.x * 0.2
			body.velocity.y = dash_velocity.y * 0.2
			_post_dash_momentum = dash_velocity.x
			_post_dash_timer = _post_dash_duration
		return sign(dash_velocity.x) if dash_velocity.x != 0 else 0.0

	if _post_dash_timer > 0.0:
		_post_dash_timer -= get_process_delta_time()

	if wall and wall.ignore_wall_input:
		return sign(body.velocity.x)

	var direction = input.get_horizontal()
	body.velocity.x = direction * speed if direction else move_toward(body.velocity.x, 0, speed)
	return direction

func handle_jump(body: CharacterBody2D) -> void:
	if not input.is_jump_pressed():
		return
	if body.is_on_floor():
		body.velocity.y = jump_velocity
		if _post_dash_timer > 0.0:
			body.velocity.x = _post_dash_momentum * 1.3
			body.velocity.y = jump_velocity * 1.15
			_post_dash_timer = 0.0
		return
	if dash_active:
		body.velocity.y = jump_velocity
		body.velocity.x = dash_velocity.x
		dash_active = false
		return

func handle_dash(body: CharacterBody2D) -> void:
	if not input.is_dash_pressed():
		return
	if not dash_available:
		return

	var dir = input.get_direction()
	if dir == Vector2.ZERO:
		var sprite = body.get_node("AnimatedSprite2D")
		dir.x = -1.0 if sprite.flip_h else 1.0

	dir = dir.normalized()
	dash_velocity = dir * dash_speed
	dash_active = true
	dash_available = false
	dash_timer = dash_duration

	if not body.is_on_floor() and body.velocity.y < 0:
		body.velocity.x = dash_velocity.x * 1.3
		body.velocity.y = minf(body.velocity.y * 1.2, jump_velocity * 1.2)
		dash_active = false
		dash_available = false
