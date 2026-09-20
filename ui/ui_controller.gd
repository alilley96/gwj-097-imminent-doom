class_name UIController
extends Control

# Signals ----------------------------------------------------------------

signal play()
signal quit()


# Exports ----------------------------------------------------------------

@export var play_button: Button
@export var settings_button: Button
@export var quit_button: Button


# Lifecycle Functions ----------------------------------------------------------------

func _ready() -> void:
	play_button.pressed.connect(_play)
	settings_button.pressed.connect(_settings)
	quit_button.pressed.connect(_quit)


# Private functions ----------------------------------------------------------------

func _play() -> void:
	play.emit()


func _settings() -> void:
	pass


func _quit() -> void:
	quit.emit()


# Public functions ----------------------------------------------------------------

func enable() -> void:
	self.visible = true


func disable() -> void:
	self.visible = false