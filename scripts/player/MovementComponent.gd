extends Node
class_name MovementComponent

@export var speed: float = 125.0
@export var jump_velocity: float = -300.0
@export var dash_speed: float = 425.0
@export var dash_duration: float = 0.15
@export var acceleration: float = 800.0   # vitesse d'accélération
@export var friction: float = 300.0       # vitesse de décélération au sol
@export var air_friction: float = 100.0   # décélération dans les airs

var input: InputComponent

# --- dash
var dash_action: String = "Button 2"
var dash_available: bool = true
var dash_active: bool = false
var dash_timer: float = 0.0
var dash_velocity: Vector2 = Vector2.ZERO
var _post_dash_timer: float = 0.0

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
		return sign(dash_velocity.x) if dash_velocity.x != 0 else 0.0

	if _post_dash_timer > 0.0:
		_post_dash_timer -= get_process_delta_time()

	if wall and wall.ignore_wall_input:
		return sign(body.velocity.x)

	var direction = input.get_horizontal()
	var delta = get_process_delta_time()

	if direction != 0:
		# accélération progressive vers la vitesse max
		body.velocity.x = move_toward(body.velocity.x, direction * speed, acceleration * delta)
	else:
		# friction différente au sol et dans les airs
		var current_friction = friction if body.is_on_floor() else air_friction
		body.velocity.x = move_toward(body.velocity.x, 0.0, current_friction * delta)

	return direction

func handle_jump(body: CharacterBody2D) -> void:
	if not input.is_jump_pressed():
		return
		
	if body.is_on_floor():
		body.velocity.y = jump_velocity

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
