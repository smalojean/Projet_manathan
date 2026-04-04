extends Node
class_name StatsComponent

signal stamina_changed(new_value: float, max_value: float)
signal health_changed(new_value: float, max_value: float)

@export var max_health: float = 30.0
@export var max_stamina: float = 100.0

var health: float = max_health
var stamina: float = max_stamina

func lose_stamina(amount: float) -> void:
	stamina = max(0.0, stamina - amount)
	emit_signal("stamina_changed", stamina, max_stamina)
	
func gain_stamina(amount: float) -> void:
	stamina = min(max_stamina, stamina + amount)
	emit_signal("stamina_changed", stamina, max_stamina)

func lose_health(amount: float) -> void:
	health = max(0.0, health - amount)
	emit_signal("health_changed", health, max_health)
