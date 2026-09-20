class_name Player
extends Node2D

# Signals ----------------------------------------------------------------

signal no_health
signal state_changed(state: PlayerState)


# Exports ----------------------------------------------------------------
		
@export var max_health: float = 100.0
@export var body_sprite: AnimatedSprite2D
@export var face_sprite: AnimatedSprite2D


# Public variables ----------------------------------------------------------------

var health: float = max_health
var current_state: PlayerState = PlayerStates.CONTENT


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	reset()


# Public Functions ----------------------------------------------------------------

func apply_damage(amount: float) -> void:
	health -= amount
	if health <= 0.0:
		no_health.emit()


func regen_health(amount: float) -> void:
	health += amount
	if health > max_health:
		health = max_health


func tick() -> void:
	for state in PlayerStates.STATES:
		if health < state.health_threshold:
			var next_state = state
			if next_state != current_state:
				state_changed.emit(state)
			current_state = next_state
			break
		
	face_sprite.animation = current_state.face_animation_name
	body_sprite.speed_scale = current_state.breathing_speed


func reset() -> void:
	health = max_health
	current_state = PlayerStates.CONTENT
	face_sprite.animation = PlayerStates.CONTENT.face_animation_name
	body_sprite.speed_scale = PlayerStates.CONTENT.breathing_speed
	face_sprite.play()
	body_sprite.play()
