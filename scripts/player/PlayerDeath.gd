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
	animation.last_animation = "death"
	body.animated_sprite.play("death")
	await body.get_tree().create_timer(1).timeout
	_respawn()
	body.is_finished = false
	animation.last_animation = ""
	body.is_dead = false
	animation.play("idle")

func _respawn() -> void:
	var checkpoint = race.last_checkpoint
	if checkpoint:
		body.global_position = checkpoint.get_spawn_position()
	else:
		var spawner = body.get_tree().get_first_node_in_group("spawner")
		if spawner:
			body.global_position = spawner.global_position + Vector2(0, -13)
		race.reset()
