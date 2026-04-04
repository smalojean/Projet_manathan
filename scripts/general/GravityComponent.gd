extends Node

class_name GravityComponent

func apply(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
