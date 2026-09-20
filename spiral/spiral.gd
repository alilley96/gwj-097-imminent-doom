class_name Spiral
extends Node2D

# Signals

signal completed(spiral: Spiral)


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze: SpiralMaze
@export var ball: Node2D
@export var damage_per_second: float = 2.0

@export var health_regen: float = 10.0


# Constants ----------------------------------------------------------------

const MAZE_ROTATION_FACTOR: float = 10.0
const MAZE_ROTATION_SENSITIVITY: float = 0.15


# Private Variables ----------------------------------------------------------------

var _maze_rotation: float = 0.0


# Public Variables ----------------------------------------------------------------

var spawn_point: SpiralSpawnPoint = null


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.animation = "spawn"
	thought_bubble_sprite.play()
	thought_bubble_sprite.animation_looped.connect(_sprite_animation_looped)

	ball.position = maze.ball_spawn_point.position

	maze.completed.connect(_maze_completed)


func _process(delta: float) -> void:
	maze.rotation = lerp(maze.rotation, _maze_rotation, delta * MAZE_ROTATION_FACTOR)


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	_maze_rotation += MAZE_ROTATION_SENSITIVITY


func rotate_counter_clockwise() -> void:
	_maze_rotation -= MAZE_ROTATION_SENSITIVITY


func destroy() -> void:
	thought_bubble_sprite.animation = "pop"
	thought_bubble_sprite.sprite_frames.set_animation_loop("pop", false)
	thought_bubble_sprite.animation_finished.connect(queue_free)
	
	maze.visible = false
	ball.visible = false


# Private Functions -----------------------------------------------------------------

func _maze_completed() -> void:
	completed.emit(self)


func _sprite_animation_looped() -> void:
	thought_bubble_sprite.animation = "idle"
	maze.spawn()
	thought_bubble_sprite.animation_looped.disconnect(_sprite_animation_looped)
