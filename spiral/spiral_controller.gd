class_name SpiralController
extends Node

# Signals ----------------------------------------------------------------

signal damage(amount: float)
signal completed(amount: float)


# Exports ----------------------------------------------------------------

@export var spiral_spawn_rate: float
@export var spiral_spawn_timer: Timer
@export var spiral_spawn_points: Array[SpiralSpawnPoint]


# Constants ----------------------------------------------------------------

var SPIRAL_SCENE: PackedScene = preload("res://spiral/spiral.tscn")
var MIN_SPIRAL_SECONDS: float = 2.0
var MAX_SPIRAL_SECONDS: float = 10.0
var MIN_SPIRAL_DAMAGE: int = 5
var MAX_SPIRAL_DAMAGE: int = 30
var MIN_SPIRAL_HEALTH_REGEN: int = 5
var MAX_SPIRAL_HEALTH_REGEN: int = 20


# Private Variables ----------------------------------------------------------------

var _spirals: Array[Spiral]


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	spiral_spawn_timer.wait_time = spiral_spawn_rate
	spiral_spawn_timer.timeout.connect(_spawn_spiral)
	

# Private functions ----------------------------------------------------------------

func _spawn_spiral() -> void:
	var spawn_point := _get_free_spawn_point()
	if spawn_point == null:
		return

	var new_spiral := SPIRAL_SCENE.instantiate()
	spawn_point.active_spiral = new_spiral
	new_spiral.spawn_point = spawn_point

	new_spiral.position = spawn_point.position
	new_spiral.expiration_time_seconds = randf_range(MIN_SPIRAL_SECONDS, MAX_SPIRAL_SECONDS)
	new_spiral.damage = randf_range(MIN_SPIRAL_DAMAGE, MAX_SPIRAL_DAMAGE)
	new_spiral.health_regen = randf_range(MIN_SPIRAL_HEALTH_REGEN, MAX_SPIRAL_HEALTH_REGEN)


	_spirals.append(new_spiral)

	new_spiral.completed.connect(_spiral_completed)
	new_spiral.failed.connect(_spiral_failed)

	add_child(new_spiral)


func _get_free_spawn_point() -> SpiralSpawnPoint:
	var free_spawn_points: Array[SpiralSpawnPoint] = []
	for point in spiral_spawn_points:
		if not point.active_spiral:
			free_spawn_points.append(point)

	if free_spawn_points.size() == 0:
		return null

	var random_index := randi() % free_spawn_points.size()
	var spawn_point := free_spawn_points[random_index]

	return spawn_point


func _spiral_completed(completed_spiral: Spiral) -> void:
	completed.emit(completed_spiral.health_regen)

	_spirals.erase(completed_spiral)

	completed_spiral.completed.disconnect(_spiral_completed)

	completed_spiral.spawn_point.active_spiral = null
	completed_spiral.destroy()


func _spiral_failed(failed_spiral: Spiral) -> void:
	damage.emit(failed_spiral.damage)

	_spirals.erase(failed_spiral)

	failed_spiral.failed.disconnect(_spiral_failed)
	
	failed_spiral.spawn_point.active_spiral = null
	failed_spiral.destroy()


# Public functions ----------------------------------------------------------------

func rotate_spirals_clockwise() -> void:
	for spiral in _spirals:
		spiral.rotate_clockwise()
	

func rotate_spirals_counter_clockwise() -> void:
	for spiral in _spirals:
		spiral.rotate_counter_clockwise()
