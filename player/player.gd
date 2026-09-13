class_name Player
extends Node2D

# Signals ----------------------------------------------------------------

signal no_health


# Exports ----------------------------------------------------------------
		
@export var max_health: float = 100.0
@export var body_sprite: AnimatedSprite2D
@export var face_sprite: AnimatedSprite2D


# Private variables ----------------------------------------------------------------

var _health: float = max_health


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	body_sprite.play()
	face_sprite.play()


# Public Functions ----------------------------------------------------------------

func apply_damage(amount: float) -> void:
	_health -= amount
	if _health <= 0.0:
		no_health.emit()


func regen_health(amount: float) -> void:
	_health += amount
	if _health > max_health:
		_health = max_health


func tick() -> void:
	var current_state := PlayerStates.CONTENT
	
	for state in PlayerStates.STATES:
		if _health < state.health_threshold:
			current_state = state
			break
		
	face_sprite.animation = current_state.face_animation_name
	body_sprite.speed_scale = current_state.breathing_speed
