extends Node
class_name WallComponent

@export var wall_slide_gravity: float = 50.0
@export var wall_jump_velocity_y: float = -300.0
@export var wall_jump_velocity_x: float = 200.0

var _ignore_wall_input_timer: float = 0.0
var ignore_wall_input: bool = false

func _process(delta: float) -> void:
	if _ignore_wall_input_timer > 0.0:
		_ignore_wall_input_timer -= delta
		ignore_wall_input = true
	else:
		ignore_wall_input = false

func is_on_wall_only(body: CharacterBody2D) -> bool:
	return body.is_on_wall() and not body.is_on_floor()

func is_wall_sliding(body: CharacterBody2D) -> bool:
	return is_on_wall_only(body) and body.velocity.y > 0

func apply_wall_slide(body: CharacterBody2D, _delta: float) -> void:
	if ignore_wall_input:
		return
	if is_on_wall_only(body):
		if body.velocity.y > 0:
			body.velocity.y = move_toward(body.velocity.y, wall_slide_gravity, wall_slide_gravity)

func handle_wall_jump(body: CharacterBody2D, input: InputComponent) -> void:
	if not input.is_jump_pressed():
		return
	if not is_on_wall_only(body):
		return
	body.velocity.y = wall_jump_velocity_y
	body.velocity.x = body.get_wall_normal().x * wall_jump_velocity_x
	_ignore_wall_input_timer = 0.35
