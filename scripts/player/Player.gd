extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var gravity = $GravityComponent
@onready var stats = $StatsComponent
@onready var input_component: InputComponent = $InputComponent
@onready var movement = $MovementComponent
@onready var wall = $WallComponent
@onready var anim: PlayerAnimation = $PlayerAnimation
@onready var death: PlayerDeath = $PlayerDeath
@onready var race: RaceManager = $RaceManager

var was_on_floor: bool = false
var is_dead: bool = false
var is_finished: bool = false

func _ready() -> void:
	animated_sprite.z_index = 1
	anim.setup(animated_sprite)
	death.setup(self, anim, race)
	movement.setup(input_component)

func _physics_process(delta: float) -> void:
	if is_dead or is_finished:
		return
	gravity.apply(self, delta)
	wall.apply_wall_slide(self, delta)
	var direction = movement.handle_movement(self, wall)
	move_and_slide()
	movement.handle_dash(self)
	movement.handle_jump(self)
	wall.handle_wall_jump(self, input_component)
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	anim.update(self, wall, direction, was_on_floor)
	was_on_floor = is_on_floor()

func set_checkpoint(checkpoint: Checkpoint) -> void:
	race.set_checkpoint(checkpoint)

func die() -> void:
	death.die()

func finish() -> void:
	is_finished = true
	race.finish()
