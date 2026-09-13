class_name Player
extends Node2D

# Signals ----------------------------------------------------------------

signal no_health


# Exports ----------------------------------------------------------------
		
@export var initial_health: float = 20.0
@export var health_timer: Timer
@export var body_sprite: AnimatedSprite2D
@export var face_sprite: AnimatedSprite2D


# Public variables ----------------------------------------------------------------

var health: float:
	get:
		return health_timer.time_left


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	health_timer.wait_time = initial_health
	health_timer.start()
	health_timer.timeout.connect(_on_health_timer_timeout)
	
	body_sprite.play()
	face_sprite.play()


func _process(_delta: float) -> void:
	var current_state = PlayerStates.CONTENT
	
	for state in PlayerStates.STATES:
		if health < state.health_threshold:
			current_state = state
			break
		
	face_sprite.animation = current_state.face_animation_name
	body_sprite.speed_scale = current_state.breathing_speed


# Private Functions ----------------------------------------------------------------

func _on_health_timer_timeout() -> void:
	no_health.emit()
