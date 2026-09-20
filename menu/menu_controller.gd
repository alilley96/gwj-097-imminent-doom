class_name MenuController
extends Node2D

# Signals ----------------------------------------------------------------

signal play()
signal quit()


# Exports ----------------------------------------------------------------

@export var play_button: BubbleButton
@export var quit_button: BubbleButton

@export var logo_thought_sprite: BubbleSprite
@export var logo_spiral_sprite: BubbleSprite


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	play_button.pressed.connect(_play)
	quit_button.pressed.connect(_quit)


# Private functions ----------------------------------------------------------------

func _play() -> void:
	play.emit()


func _quit() -> void:
	quit.emit()


# Public functions ----------------------------------------------------------------

func enable() -> void:
	play_button.spawn()
	quit_button.spawn()
	logo_thought_sprite.spawn()
	logo_spiral_sprite.spawn()


func disable() -> void:
	play_button.pop()
	quit_button.pop()
	logo_thought_sprite.pop()
	logo_spiral_sprite.pop()
