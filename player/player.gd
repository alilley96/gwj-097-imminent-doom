class_name Player
extends Node3D

# Signals ----------------------------------------------------------------

signal no_health


# Exports ----------------------------------------------------------------
		
@export var initial_health: float = 20.0
@export var health_timer: Timer
@export var body_sprite: AnimatedSprite3D
@export var face_sprite: AnimatedSprite3D

@export var states_ordered: Array[StringName] = [
	"doomed",
	"anxious",
	"not_great",
	"neutral",
	"content"
]


# Constants ----------------------------------------------------------------

var BREATHING_SPEED_FACTOR: float = 0.4


# Public variables ----------------------------------------------------------------

var health: float:
	get:
		return health_timer.time_left


# Private variables ----------------------------------------------------------------

var _state_count: int = states_ordered.size()
var _state_threshold_step_size: float = initial_health / _state_count


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	health_timer.wait_time = initial_health
	health_timer.start()
	health_timer.timeout.connect(_on_health_timer_timeout)
	
	body_sprite.play()
	face_sprite.animation = "content"
	face_sprite.play()


func _process(delta: float) -> void:
	var current_state = "content"
	var breathing_speed = 1.0
	
	for i in range(_state_count):
		var threshold = (i + 1) * _state_threshold_step_size
		if health < threshold:
			current_state = states_ordered[i]
			breathing_speed = _state_count / (i + 1)
			break
		
	face_sprite.animation = current_state
	body_sprite.speed_scale = breathing_speed * BREATHING_SPEED_FACTOR


# Private Functions ----------------------------------------------------------------

func _on_health_timer_timeout() -> void:
	no_health.emit()
