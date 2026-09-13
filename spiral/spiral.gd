class_name Spiral
extends Node2D

# Signals

signal damage()


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze_container: StaticBody2D
@export var damage_timer: Timer


# Private variables ----------------------------------------------------------------

var _damage_per_second: float = 5.0


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.play()

	damage_timer.wait_time = 1.0
	damage_timer.timeout.connect(_damage_timer_timeout)
	damage_timer.one_shot = false
	damage_timer.start()


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	maze_container.rotate(0.1)


func rotate_counter_clockwise() -> void:
	maze_container.rotate(-0.1)


# Private Functions -----------------------------------------------------------------

func _damage_timer_timeout() -> void:
	damage.emit(_damage_per_second)
