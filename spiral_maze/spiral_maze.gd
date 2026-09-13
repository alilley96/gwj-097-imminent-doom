class_name SpiralMaze
extends StaticBody2D

# Signals

signal completed()


# Exports ----------------------------------------------------------------

@export var maze_end_area: Area2D
@export var ball_spawn_point: Node2D


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	maze_end_area.body_entered.connect(_maze_completed)


# Private Functions -----------------------------------------------------------------

func _maze_completed(_body: Node2D) -> void:
	completed.emit()
