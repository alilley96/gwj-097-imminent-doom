class_name Spiral
extends Node2D

# Signals

signal completed(spiral: Spiral)
signal failed(spiral: Spiral)


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze: SpiralMaze
@export var ball: Node2D

@export var expiration_time_seconds: int = 10
@export var expiration_timer: Timer
@export var timer_progress_bar: ProgressBar
@export var timer_progress_bar_label: Label

@export var damage_bubble_sprite: BubbleSprite
@export var damage_bubble_label: Label
@export var health_bubble_sprite: BubbleSprite
@export var health_bubble_label: Label

@export var damage: int = 10
@export var health_regen: int = 10


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

	expiration_timer.wait_time = expiration_time_seconds
	expiration_timer.start()
	expiration_timer.timeout.connect(_on_timer_expired)

	timer_progress_bar.max_value = expiration_time_seconds
	timer_progress_bar.min_value = 0.0

	damage_bubble_sprite.spawn()
	damage_bubble_label.text = str(damage) + " dmg"
	health_bubble_sprite.spawn()
	health_bubble_label.text = str(health_regen) + " hp"


func _process(delta: float) -> void:
	maze.rotation = lerp(maze.rotation, _maze_rotation, delta * MAZE_ROTATION_FACTOR)
	timer_progress_bar.value = expiration_timer.time_left
	timer_progress_bar_label.text = String.num(timer_progress_bar.value, 1) + "s"


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	_maze_rotation += MAZE_ROTATION_SENSITIVITY


func rotate_counter_clockwise() -> void:
	_maze_rotation -= MAZE_ROTATION_SENSITIVITY


func destroy() -> void:
	thought_bubble_sprite.animation = "pop"
	thought_bubble_sprite.sprite_frames.set_animation_loop("pop", false)
	
	if not thought_bubble_sprite.animation_finished.is_connected(queue_free):
		thought_bubble_sprite.animation_finished.connect(queue_free)

	damage_bubble_sprite.pop()
	health_bubble_sprite.pop()

	health_bubble_label.visible = false
	damage_bubble_label.visible = false
	
	maze.visible = false
	ball.visible = false
	timer_progress_bar.visible = false
	expiration_timer.stop()


# Private Functions -----------------------------------------------------------------

func _maze_completed() -> void:
	completed.emit(self)


func _sprite_animation_looped() -> void:
	thought_bubble_sprite.animation = "idle"
	maze.spawn()
	thought_bubble_sprite.animation_looped.disconnect(_sprite_animation_looped)


func _on_timer_expired() -> void:
	failed.emit(self)
