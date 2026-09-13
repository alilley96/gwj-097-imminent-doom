class_name Spiral
extends Node3D


# Exports ----------------------------------------------------------------

@export var thought_bubble_spite: AnimatedSprite3D


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	thought_bubble_spite.play()
