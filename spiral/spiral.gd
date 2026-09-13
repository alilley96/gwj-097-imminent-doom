class_name Spiral
extends Node3D


# Exports ----------------------------------------------------------------

@export var thought_bubble_sprite: AnimatedSprite3D


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_sprite.play()


# Public Functions ----------------------------------------------------------------

func rotate_clockwise() -> void:
	rotate(Vector3.FORWARD, 0.1)


func rotate_counter_clockwise() -> void:
	rotate(Vector3.FORWARD, -0.1)
