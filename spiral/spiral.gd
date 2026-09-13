class_name Spiral
extends Node2D


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite2D
@export var maze_container: StaticBody2D

# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.play()


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	maze_container.rotate(0.1)


func rotate_counter_clockwise() -> void:
	maze_container.rotate(-0.1)
