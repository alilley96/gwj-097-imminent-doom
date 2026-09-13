class_name Spiral
extends Node2D

# Signals

signal completed(spiral: Spiral)


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze: SpiralMaze
@export var ball: Node2D
@export var damage_per_second: float = 5.0

@export var health_regen: float = 10.0


# Public Variables ----------------------------------------------------------------

var spawn_point: SpiralSpawnPoint = null


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.animation = "default"
	thought_bubble_sprite.play()

	ball.position = maze.ball_spawn_point.position

	maze.completed.connect(_maze_completed)


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	maze.rotate(0.1)


func rotate_counter_clockwise() -> void:
	maze.rotate(-0.1)


func destroy() -> void:
	thought_bubble_sprite.animation = "pop"
	thought_bubble_sprite.sprite_frames.set_animation_loop("pop", false)
	thought_bubble_sprite.animation_finished.connect(queue_free)
	
	maze.visible = false
	ball.visible = false


# Private Functions -----------------------------------------------------------------

func _maze_completed() -> void:
	completed.emit(self)
