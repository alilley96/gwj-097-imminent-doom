class_name Spiral
extends Node2D

# Signals

signal damage()
signal completed(spiral: Spiral, health_regen: float)


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze_container: StaticBody2D
@export var damage_timer: Timer
@export var maze_end_area: Area2D

@export var health_regen: float = 10.0


# Public Variables ----------------------------------------------------------------

var spawn_point: SpiralSpawnPoint = null


# Private variables ----------------------------------------------------------------

var _damage_per_second: float = 5.0


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.play()

	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_damage_timer_timeout)
	damage_timer.one_shot = false
	damage_timer.start()

	maze_end_area.body_entered.connect(_maze_completed)


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	maze_container.rotate(0.1)


func rotate_counter_clockwise() -> void:
	maze_container.rotate(-0.1)


# Private Functions -----------------------------------------------------------------

func _damage_timer_timeout() -> void:
	damage.emit(_damage_per_second)


func _maze_completed(_body: Node2D) -> void:
	completed.emit(self, health_regen)
