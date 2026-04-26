extends Node
class_name PlayerDeath

var body: CharacterBody2D
var animation: PlayerAnimation
var race: RaceManager

func setup(p_body: CharacterBody2D, p_animation: PlayerAnimation, p_race: RaceManager) -> void:
	body = p_body
	animation = p_animation
	race = p_race

func die() -> void:
	if body.is_dead:
		return

	body.is_dead = true
	animation.is_locked = true
	animation.state = PlayerAnimation.State.DIE
	body.animated_sprite.play("death")

	await body.get_tree().create_timer(1).timeout

	_respawn()

	body.is_finished = false
	animation.is_locked = false
	body.is_dead = false
	animation.set_state(PlayerAnimation.State.IDLE)

func _respawn() -> void:
	var spawner = body.get_tree().get_first_node_in_group("spawner")

	if spawner:
		body.global_position = spawner.global_position + Vector2(0, -13)

	race.reset()
	get_tree().reload_current_scene()
