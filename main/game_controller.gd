class_name GameController
extends Node

# Exports ----------------------------------------------------------------

@export var player: Player
@export var light: OmniLight3D

@export var spiral_spawn_rate: float
@export var spiral_spawn_timer: Timer
@export var spiral_spawn_points: Array[SpiralSpawnPoint]

# Constants ----------------------------------------------------------------

var SPIRAL_SCENE: PackedScene = preload("res://spiral/spiral.tscn")


# Private Variables ----------------------------------------------------------------

var _spirals: Array[Spiral]


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	player.no_health.connect(_game_over)
	
	spiral_spawn_timer.wait_time = spiral_spawn_rate
	spiral_spawn_timer.timeout.connect(_spawn_spiral)
	spiral_spawn_timer.start()
	

func _process(delta: float) -> void:
	if player.health > 0.0:
		light.light_energy = player.health


# Private functions ----------------------------------------------------------------

func _game_over() -> void:
	print("Game Over!")


func _spawn_spiral() -> void:
	var free_spawn_points = []
	for point in spiral_spawn_points:
		if not point.in_use:
			free_spawn_points.append(point)

	if free_spawn_points.size() == 0:
		return

	var random_index = randi() % free_spawn_points.size()
	var spawn_point = free_spawn_points[random_index]
	spawn_point.in_use = true

	var new_spiral = SPIRAL_SCENE.instantiate()
	new_spiral.position = spawn_point.position
	add_child(new_spiral)
