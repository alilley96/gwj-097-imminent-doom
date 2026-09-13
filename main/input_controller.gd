class_name InputController
extends Node

# Signals ----------------------------------------------------------------

signal rotate_clockwise()
signal rotate_counter_clockwise()
signal pause()


# Lifecycle Functions ----------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_clockwise"):
		rotate_clockwise.emit()
	elif event.is_action_pressed("rotate_counter_clockwise"):
		rotate_counter_clockwise.emit()
	elif event.is_action_pressed("pause"):
		pause.emit()
	else:
		pass
