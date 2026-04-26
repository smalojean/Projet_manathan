extends Node
class_name InputComponent

signal reset_requested

@export var reset_hold_time: float = 1.5

var _reset_timer: float = 0.0
var _reset_triggered: bool = false

# --- mouvement
func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

func get_horizontal() -> float:
	return Input.get_axis("ui_left", "ui_right")

# --- actions
func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("Button 0")

func is_dash_pressed() -> bool:
	return Input.is_action_just_pressed("Button 2")

func is_jump_held() -> bool:
	return Input.is_action_pressed("Button 0")

func is_start_pressed() -> bool:
	return Input.is_action_just_pressed("Button 6")
	
 
# --- reset
func _process(delta: float) -> void:
	if Input.is_action_pressed("Button 9") and Input.is_action_pressed("Button 10"):
		_reset_timer += delta

		if _reset_timer >= reset_hold_time and not _reset_triggered:
			_reset_triggered = true
			reset_requested.emit()
	else:
		_reset_timer = 0.0
		_reset_triggered = false
