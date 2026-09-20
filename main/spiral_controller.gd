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
	_spirals.append(new_spiral)

	new_spiral.completed.connect(_spiral_completed)

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


# Public functions ----------------------------------------------------------------

func tick(delta: float) -> void:
	var frame_damage := 0.0
	for spiral in _spirals:
		frame_damage += spiral.damage_per_second

	frame_damage *= delta

	damage.emit(frame_damage)


func rotate_spirals_clockwise() -> void:
	for spiral in _spirals:
		spiral.rotate_clockwise()
	

func rotate_spirals_counter_clockwise() -> void:
	for spiral in _spirals:
		spiral.rotate_counter_clockwise()
