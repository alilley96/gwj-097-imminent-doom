class_name Spiral
extends Node2D

# Signals

signal completed(spiral: Spiral)


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze_container: StaticBody2D
@export var ball: Node2D
@export var damage_per_second: float = 5.0
@export var maze_end_area: Area2D

@export var health_regen: float = 10.0


# Public Variables ----------------------------------------------------------------

var spawn_point: SpiralSpawnPoint = null


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.animation = "default"
	thought_bubble_sprite.play()

	maze_end_area.body_entered.connect(_maze_completed)


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	maze_container.rotate(0.1)


func rotate_counter_clockwise() -> void:
	maze_container.rotate(-0.1)


func destroy() -> void:
	thought_bubble_sprite.animation = "pop"
	thought_bubble_sprite.sprite_frames.set_animation_loop("pop", false)
	thought_bubble_sprite.animation_finished.connect(queue_free)
	
	maze_container.visible = false
	ball.visible = false


# Private Functions -----------------------------------------------------------------

func _maze_completed(_body: Node2D) -> void:
	completed.emit(self)
